Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZBLCgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZBLCgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZBLCgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:36:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:37941 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZBLCgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lsy7JshfGD2uF7b9AmFgZn58SSZzBbTsuOlpASjdQMsOg9SWCqaggAUTBw++oqMowQ
         xP82OFp59cUVvBdFrS80sh4W3K62U/6N/7KPPqtENlqF3wXxbgeAxzfNVrs4t7AL8gTe
         Ycgx6ubknY+EZTDQpr1n8W7Lbn/uYwaL+tjXU=
Message-ID: <49938B2C.1020407@gmail.com>
Date: Wed, 11 Feb 2009 18:36:28 -0800
From: Joshua D Doll <joshua.doll@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Gabriel C <crazy@frugalware.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for temp/voltage
 monitoring)
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>	<4964DB3E.6080908@intel.com>	<alpine.DEB.1.10.0901071142200.29147@p34.internal.lan> <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>
In-Reply-To: <49937CDF.10307@frugalware.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Maxim Levitsky wrote:
>
>   
>> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>>     
>>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>>
>>>       
>>>> Justin Piszcz wrote:
>>>>         
>>>>> The HECI interface would allow lm_sensors developers to grab the
>>>>> temperatures off the chips on the board.
>>>>>
>>>>> From 2005(?)-2008 there was some chatter about supporting it but it never
>>>>> seemed to happen, is there any eventual planned support for supporting
>>>>> Intel's HECI interface or if the user wants to see the
>>>>> temperatures/voltages just buy a different motherboard with an ITE I/O
>>>>> controller?
>>>>>
>>>>> I have a couple DG965WH boards and it would be nice to see the
>>>>> temperature of the chipset etc without having to reboot into the BIOS.
>>>>>
>>>>>           
>>>> Hi Justin,
>>>>
>>>> I am not up to date on the progress in this area, but perhaps this site 
>>>> (http://www.openamt.org/) has what you are looking for?
>>>>
>>>> Regards,
>>>> Dan
>>>>
>>>>         
>>> Yeah that is the site-- however, will it ever get merged?  I have not 
>>> heard anything about it for a year or so.
>>>       
>> Nope, the heci is just a controller, but we need a way to tell that
>> controller to show us the temperature data.
>> But intel hasn't released the QST sdk, and probably never will.
>>
>> Sad, 
>>     
>
>
> Well I found this interesting thread about :
>
> http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/
>
> It looks like the QST SDK already exists and is planned to be released..
> (  http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/reply/74068/ )
>
>   
>> Best regards,
>> 	Maxim Levitsky
>>
>>     
>
> Gabriel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
This is good news. I know lots of users are waiting for this.

--Joshua Doll
