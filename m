Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0CLFUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 00:20:50 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:43510 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab0CLFUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 00:20:48 -0500
Message-ID: <4B99CEFE.2080505@st.com>
Date: Fri, 12 Mar 2010 10:49:58 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/11] ST SPEAr: Added ARM PrimeXsys System Controller
 SP810 header file
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <63386a3d1003091214s5251674et99903756f3528e66@mail.gmail.com> <20100311104552.GD16376@n2100.arm.linux.org.uk>
In-Reply-To: <20100311104552.GD16376@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 4:15 PM, Russell King - ARM Linux wrote:
> On Tue, Mar 09, 2010 at 09:14:53PM +0100, Linus Walleij wrote:
>> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
>>
>>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>>> ---
>>>  include/linux/sysctl_sp810.h |   59 ++++++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 59 insertions(+), 0 deletions(-)
>>>  create mode 100644 include/linux/sysctl_sp810.h
>>> (...)
>>
>> To the rest of the world this is probably a number of register definitions and
>> an obscure inline function, so the entire internal kernel API does not need
>> to know about it.
> 
> It'll also give people heart-attacks because they'll think it adds a new
> set of deprecated binary sysctl() interfaces to the kernel.
> 
> Best drop the 'sysctl' part of the name as well.
> 

OK. will be removed.
