Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0CJFKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:10:18 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:42198 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab0CJFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:10:14 -0500
Message-ID: <4B972983.7090307@st.com>
Date: Wed, 10 Mar 2010 10:39:23 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 01/11] ST SPEAr: Added ARM PrimeXsys System Controller
 	SP810 header file
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <63386a3d1003091214s5251674et99903756f3528e66@mail.gmail.com>
In-Reply-To: <63386a3d1003091214s5251674et99903756f3528e66@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On 3/10/2010 1:44 AM, Linus Walleij wrote:
> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> 
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  include/linux/sysctl_sp810.h |   59 ++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 59 insertions(+), 0 deletions(-)
>>  create mode 100644 include/linux/sysctl_sp810.h
>> (...)
> 
> To the rest of the world this is probably a number of register definitions and
> an obscure inline function, so the entire internal kernel API does not need
> to know about it.
> 
> Move it to arch/arm/include/asm/hardware

OK.


viresh
