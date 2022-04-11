#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <bar/Bar.hpp>

namespace py = pybind11;

PYBIND11_MODULE(bar, m) {
    m.doc() = "bar module"; // optional module docstring

    // Free function
    // Vector of String
    m.def("string_vector_output", &::bar::stringVectorOutput, "A function that return a vector of string.");
    m.def("string_vector_input", &::bar::stringVectorInput, "A function that use a vector of string.");
    m.def("string_vector_ref_input", &::bar::stringVectorInput, "A function that use a vector of string const ref.");

    // Vector of Vector of String
    m.def("string_jagged_array_output", &::bar::stringJaggedArrayOutput, "A function that return a jagged array of string.");
    m.def("string_jagged_array_input", &::bar::stringJaggedArrayInput, "A function that use a jagged array of string.");
    m.def("string_jagged_array_ref_input", &::bar::stringJaggedArrayRefInput, "A function that use a jagged array of string const ref.");

    // Vector of Pair
    m.def("pair_vector_output", &::bar::pairVectorOutput, "A function that return a vector of pair.");
    m.def("pair_vector_input", &::bar::pairVectorInput, "A function that use a vector of pair.");
    m.def("pair_vector_ref_input", &::bar::pairVectorRefInput, "A function that use a vector of pair const ref.");

    // Vector of Vector of Pair
    m.def("pair_jagged_array_output", &::bar::pairJaggedArrayOutput, "A function that return a jagged array of pair.");
    m.def("pair_jagged_array_input", &::bar::pairJaggedArrayInput, "A function that use a jagged array of pair.");
    m.def("pair_jagged_array_ref_input", &::bar::pairJaggedArrayRefInput, "A function that use a jagged array of pair const ref.");

    // Free Function
    m.def("free_function", py::overload_cast<int>(&::bar::freeFunction), "A free function taking an int.");
    m.def("free_function", py::overload_cast<int64_t>(&::bar::freeFunction), "A free function taking an int64.");

    // Class Bar
    py::class_<::bar::Bar>(m, "Bar")
      .def(py::init<>())
      .def_static("static_function", py::overload_cast<int>(&::bar::Bar::staticFunction))
      .def_static("static_function", py::overload_cast<int64_t>(&::bar::Bar::staticFunction))
      .def_property("int", &::bar::Bar::getInt, &::bar::Bar::setInt, py::return_value_policy::copy)
      .def_property("int64", &::bar::Bar::getInt64, &::bar::Bar::setInt64, py::return_value_policy::copy)
      .def("__str__", &::bar::Bar::operator());
}
