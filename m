Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0CHOPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:15:37 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43483 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab0CHOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:15:34 -0500
X-Greylist: delayed 1585 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 09:15:33 EST
Message-ID: <4B950042.1030007@st.com>
Date: Mon, 08 Mar 2010 14:48:50 +0100
From: Armando VISCONTI <armando.visconti@st.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: viresh kumar <viresh.linux@gmail.com>, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, ashish.priyadarshi@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, amit.goel@st.com,
       deepak.sikri@st.com
Subject: Re: [PATCH 00/11] Adding Support for SPEAr Platform under ARM 	architecture
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <22dbbef21003070754l6c99f777ycd99cfa892169736@mail.gmail.com>
In-Reply-To: <22dbbef21003070754l6c99f777ycd99cfa892169736@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

We really would like to contribute back to the linux community
with the SPEAr architecture, as we already did for the u-boot loader.

We started just adding the minimum required to boot up the system,
but we will definetely add all the remaining peripheral in the
next merging windows.

Can you possibly just spend some times on this patch set and give us
your feedback? We would really appreciate.
:-)


Thx very much,
Armando


viresh kumar wrote:
> Hello Russell,
>
> On Wed, Mar 3, 2010 at 10:37 AM, Viresh KUMAR <viresh.kumar@st.com> wrote:
>   
>> Following set of patches are for adding ST Microelctronics SPEAr Platform under
>> ARM architecture in Linux.
>>
>> Hierarchy in SPEAr is as follows:
>> SPEAr (Platform)
>>        - SPEAr3XX (3XX SOC series, based on ARM9)
>>                - SPEAr300 (SOC)
>>                        - SPEAr300_EVB (Evaluation Board)
>>                - SPEAr310 (SOC)
>>                        - SPEAr310_EVB (Evaluation Board)
>>                - SPEAr320 (SOC)
>>                        - SPEAr320_EVB (Evaluation Board)
>>        - SPEAr6XX (6XX SOC series, based on ARM9)
>>                - SPEAr600 (SOC)
>>                        - SPEAr600_EVB (Evaluation Board)
>>        - SPEAr13XX (13XX SOC series, based on ARM CORTEXA9)
>>                - SPEAr1300 (SOC)
>>
>> Current patch will add support for SPEAr3XX and SPEAr6XX family. SPEAr13XX is
>> under development phase.
>>
>>     
>
> Is this patch set fine? Or do i need resubmit it?
>
>
> regards,
> viresh kumar,
> ST Microelectronics
>   


