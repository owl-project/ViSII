// glm::vec3 bindings
%typemap(in) glm::vec3 (void *argp = 0, int res = 0) {
  int res = SWIG_ConvertPtr($input, &argp, $descriptor(glm::vec3*), $disown | 0);
  if (!SWIG_IsOK(res)) 
  { 
    if (!PySequence_Check($input)) {
      PyErr_SetString(PyExc_ValueError, "in method '" "$symname" "', argument " "$argnum" " Expected either a sequence or vec3");
      return NULL;
    }

    if (PySequence_Length($input) != 3) {
      PyErr_SetString(PyExc_ValueError,"in method '" "$symname" "', argument " "$argnum" " Size mismatch. Expected 3 elements");
      return NULL;
    }

    for (int i = 0; i < 3; i++) {
      PyObject *o = PySequence_GetItem($input,i);
      if (PyNumber_Check(o)) {
        $1[i] = (float) PyFloat_AsDouble(o);
      } else {
        PyErr_SetString(PyExc_ValueError,"in method '" "$symname" "', argument " "$argnum" " Sequence elements must be numbers");      
        return NULL;
      }
    }
  }   
  else {
    glm::vec3 * temp = reinterpret_cast< glm::vec3 * >(argp);
    $1 = *temp;
    if (SWIG_IsNewObj(res)) delete temp;
  }
}

%typemap(in) glm::vec3 const & (void *argp = 0, int res = 0, glm::vec3 tmp) {
  int res = SWIG_ConvertPtr($input, &argp, $descriptor(glm::vec3*), $disown | 0);
  if (!SWIG_IsOK(res)) 
  { 
    if (!PySequence_Check($input)) {
      PyErr_SetString(PyExc_ValueError, "in method '" "$symname" "', argument " "$argnum" " Expected either a sequence or vec3");
      return NULL;
    }

    if (PySequence_Length($input) != 3) {
      PyErr_SetString(PyExc_ValueError,"in method '" "$symname" "', argument " "$argnum" " Size mismatch. Expected 3 elements");
      return NULL;
    }

    $1 = &tmp;
    for (int i = 0; i < 3; i++) {
      PyObject *o = PySequence_GetItem($input,i);
      if (PyNumber_Check(o)) {
        (*$1)[i] = (float) PyFloat_AsDouble(o);
      } else {
        PyErr_SetString(PyExc_ValueError,"in method '" "$symname" "', argument " "$argnum" " Sequence elements must be numbers");      
        return NULL;
      }
    }
  }   
  else {
    glm::vec3 * temp = reinterpret_cast< glm::vec3 * >(argp);
    $1 = temp;
    if (SWIG_IsNewObj(res)) delete temp;
  }
}

struct vec3 {
    
    float x, y, z;

    static length_t length();

    vec3();
    vec3(vec3 const & v);
    vec3(float scalar);
    vec3(float s1, float s2, float s3);
    vec3(glm::vec2 const & a, float b);
    vec3(float a, glm::vec2 const & b);
    vec3(glm::vec4 const & v);

    /*vec3 & operator=(vec3 const & v);*/
};

vec3 operator+(vec3 const & v, float scalar);
vec3 operator+(float scalar, vec3 const & v);
vec3 operator+(vec3 const & v1, vec3 const & v2);
vec3 operator-(vec3 const & v, float scalar);
vec3 operator-(float scalar, vec3 const & v);
vec3 operator-(vec3 const & v1, vec3 const & v2);
vec3 operator*(vec3 const & v, float scalar);
vec3 operator*(float scalar, vec3 const & v);
vec3 operator*(vec3 const & v1, vec3 const & v2);
vec3 operator/(vec3 const & v, float scalar);
vec3 operator/(float scalar, vec3 const & v);
vec3 operator/(vec3 const & v1, vec3 const & v2);
/*vec3 operator%(vec3 const & v, float scalar);
vec3 operator%(float scalar, vec3 const & v);
vec3 operator%(vec3 const & v1, vec3 const & v2);*/
bool operator==(vec3 const & v1, vec3 const & v2);
bool operator!=(vec3 const & v1, vec3 const & v2);

%extend vec3 {

    // [] getter
    // out of bounds throws a string, which causes a Lua error
    float __getitem__(int i) throw (std::out_of_range) {
        #ifdef SWIGLUA
            if(i < 1 || i > $self->length()) {
                throw std::out_of_range("in glm::vec3::__getitem__()");
            }
            return (*$self)[i-1];
        #else
            if(i < 0 || i >= $self->length()) {
                throw std::out_of_range("in glm::vec3::__getitem__()");
            }
            return (*$self)[i];
        #endif
    }

    // [] setter
    // out of bounds throws a string, which causes a Lua error
    void __setitem__(int i, float f) throw (std::out_of_range) {
        #ifdef SWIGLUA
            if(i < 1 || i > $self->length()) {
                throw std::out_of_range("in glm::vec3::__setitem__()");
            }
            (*$self)[i-1] = f;
        #else
            if(i < 0 || i >= $self->length()) {
                throw std::out_of_range("in glm::vec3::__setitem__()");
            }
            (*$self)[i] = f;
        #endif
    }

    // tostring operator
    std::string __tostring() {
        std::stringstream str;
        for(glm::length_t i = 0; i < $self->length(); ++i) {
            str << (*$self)[i];
            if(i + 1 != $self->length()) {
                str << " ";
            }
        }
        return str.str();
    }

    // extend operators, otherwise some languages (lua)
    // won't be able to act on objects directly (ie. v1 + v2)
    vec3 operator+(vec3 const & v) {return (*$self) + v;}
    vec3 operator+(float scalar) {return (*$self) + scalar;}
    vec3 operator-(vec3 const & v) {return (*$self) - v;}
    vec3 operator-(float scalar) {return (*$self) - scalar;}
    vec3 operator*(vec3 const & v) {return (*$self) * v;}
    vec3 operator*(float scalar) {return (*$self) * scalar;}
    vec3 operator/(vec3 const & v) {return (*$self) / v;}
    vec3 operator/(float scalar) {return (*$self) / scalar;}
    /*vec3 operator%(vec3 const & v) {return (*$self) % v;}
    vec3 operator%(float scalar) {return (*$self) % scalar;}*/
    bool operator==(vec3 const & v) {return (*$self) == v;}
    bool operator!=(vec3 const & v) {return (*$self) != v;}
};
