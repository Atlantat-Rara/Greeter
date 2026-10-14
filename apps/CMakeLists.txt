#add the executable target named greet
add_executable(greet greet.cpp)
target_link_libraries(greet PRIVATE greeter)