Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZBLRjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZBLRjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZBLRjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:39:13 -0500
Received: from lucidpixels.com ([75.144.35.66]:37614 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbZBLRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:39:12 -0500
Date: Thu, 12 Feb 2009 12:39:11 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Gabriel C <crazy@frugalware.org>
cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for
 temp/voltage monitoring)
In-Reply-To: <49937CDF.10307@frugalware.org>
Message-ID: <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan> <4964DB3E.6080908@intel.com> <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan> <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Feb 2009, Gabriel C wrote:

> Maxim Levitsky wrote:
>
>> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>>
>>>> Justin Piszcz wrote:
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
>>>> Hi Justin,
>>>>
>>>> I am not up to date on the progress in this area, but perhaps this site
>>>> (http://www.openamt.org/) has what you are looking for?
>>>>
>>>> Regards,
>>>> Dan
>>>>
>>> Yeah that is the site-- however, will it ever get merged?  I have not
>>> heard anything about it for a year or so.
>>
>> Nope, the heci is just a controller, but we need a way to tell that
>> controller to show us the temperature data.
>> But intel hasn't released the QST sdk, and probably never will.
>>
>> Sad,
>
>
> Well I found this interesting thread about :
>
> http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/
>
> It looks like the QST SDK already exists and is planned to be released..
> (  http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/reply/74068/ )
>
>>
>> Best regards,
>> 	Maxim Levitsky
>>
>
> Gabriel

I volunteer to test any patches if/when they are created after the SDK is 
released.

Justin.
