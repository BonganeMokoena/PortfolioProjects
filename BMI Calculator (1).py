#!/usr/bin/env python
# coding: utf-8

# In[2]:


#BMI = (weight * 703) / (height * height)


# In[29]:


name = input("Enter your name: ")
weight = int(input("Enter your weight (in pounds): "))
height = int(input("Enter your height (in inches): "))

bmi = (weight * 703) / (height * height)
    
print()
if bmi > 0:
    if bmi < 18.5:
        print(name, "your BMI is ",round(bmi,1), ". You are underwight")
    elif bmi <24.9:
        print(name, "your BMI is ",round(bmi,1), ". You are normal weight")
    elif bmi < 29.9:
        print(name, "your BMI is ",round(bmi,1), ". You are overwight")
    elif bmi < 34.9:
        print(round(bmi,1), ", obese")
    elif bmi < 39.9:
        print(round(bmi,1), ", serveley obese")
    else:
        print(round(bmi,1), ", over-morbidly obese")

        
print()
done = input("Press any key to close window!")
print()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




