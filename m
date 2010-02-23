Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0BWQ4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:56:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:56894 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0BWQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:56:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CyS+ZpLSFNb8R2IcL5pcor8rV40NLBWisp/tibUVau7HMHEX4uum51424Gv5yLSHMm
         PmqjJrYzoNTyH8kQacPzmyHewGu22TmBZ2/oHS6U5Wd/vqAxc1pQuIkLzLirVHk9XRwc
         cJieSkwyczZeLQySByweV1FkDF8g2l3mim5PM=
Message-ID: <4B8416DC.4040904@frugalware.org>
Date: Tue, 23 Feb 2010 18:56:44 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Shredder/3.0.1
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for temp/voltage
 monitoring)
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan> <4964DB3E.6080908@intel.com> <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan> <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org> <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.02.2009 18:39, Justin Piszcz wrote:

> 
> 
> On Thu, 12 Feb 2009, Gabriel C wrote:
> 
>> Maxim Levitsky wrote:
>>
>>> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>>>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>>>
>>>>> Justin Piszcz wrote:
>>>>>> The HECI interface would allow lm_sensors developers to grab the
>>>>>> temperatures off the chips on the board.
>>>>>>
>>>>>> From 2005(?)-2008 there was some chatter about supporting it but
>>>>>> it never
>>>>>> seemed to happen, is there any eventual planned support for
>>>>>> supporting
>>>>>> Intel's HECI interface or if the user wants to see the
>>>>>> temperatures/voltages just buy a different motherboard with an ITE
>>>>>> I/O
>>>>>> controller?
>>>>>>
>>>>>> I have a couple DG965WH boards and it would be nice to see the
>>>>>> temperature of the chipset etc without having to reboot into the
>>>>>> BIOS.
>>>>>>
>>>>> Hi Justin,
>>>>>
>>>>> I am not up to date on the progress in this area, but perhaps this
>>>>> site
>>>>> (http://www.openamt.org/) has what you are looking for?
>>>>>
>>>>> Regards,
>>>>> Dan
>>>>>
>>>> Yeah that is the site-- however, will it ever get merged?  I have not
>>>> heard anything about it for a year or so.
>>>
>>> Nope, the heci is just a controller, but we need a way to tell that
>>> controller to show us the temperature data.
>>> But intel hasn't released the QST sdk, and probably never will.
>>>
>>> Sad,
>>
>>
>> Well I found this interesting thread about :
>>
>> http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/
>>
>>
>> It looks like the QST SDK already exists and is planned to be released..
>> ( 
>> http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/reply/74068/
>> )
>>
>>>
>>> Best regards,
>>>     Maxim Levitsky
>>>
>>
>> Gabriel
> 
> I volunteer to test any patches if/when they are created after the SDK
> is released.



Ok good news :) The QST SDK is out ..

http://software.intel.com/en-us/blogs/2010/02/18/great-news-the-intelr-qst-sdk-is-now-public/


http://software.intel.com/en-us/articles/Intel_Quiet_System_Technology_Software_Development_Kit/



Gabriel
