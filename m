Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbZBLBm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbZBLBm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZBLBmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:42:18 -0500
Received: from mailhost13.gawab.com ([66.220.20.13]:38551 "HELO
	info15.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756205AbZBLBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:42:18 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 20:42:17 EST
X-Trusted: Whitelisted
Message-ID: <49937CDF.10307@frugalware.org>
Date: Thu, 12 Feb 2009 02:35:27 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090128)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for temp/voltage
 monitoring)
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>	<4964DB3E.6080908@intel.com>	<alpine.DEB.1.10.0901071142200.29147@p34.internal.lan> <1231356111.6648.2.camel@maxim-laptop>
In-Reply-To: <1231356111.6648.2.camel@maxim-laptop>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:

> On Wed, 2009-01-07 at 11:42 -0500, Justin Piszcz wrote:
>> On Wed, 7 Jan 2009, Dan Williams wrote:
>>
>>> Justin Piszcz wrote:
>>>> The HECI interface would allow lm_sensors developers to grab the
>>>> temperatures off the chips on the board.
>>>>
>>>> From 2005(?)-2008 there was some chatter about supporting it but it never
>>>> seemed to happen, is there any eventual planned support for supporting
>>>> Intel's HECI interface or if the user wants to see the
>>>> temperatures/voltages just buy a different motherboard with an ITE I/O
>>>> controller?
>>>>
>>>> I have a couple DG965WH boards and it would be nice to see the
>>>> temperature of the chipset etc without having to reboot into the BIOS.
>>>>
>>> Hi Justin,
>>>
>>> I am not up to date on the progress in this area, but perhaps this site 
>>> (http://www.openamt.org/) has what you are looking for?
>>>
>>> Regards,
>>> Dan
>>>
>> Yeah that is the site-- however, will it ever get merged?  I have not 
>> heard anything about it for a year or so.
> 
> Nope, the heci is just a controller, but we need a way to tell that
> controller to show us the temperature data.
> But intel hasn't released the QST sdk, and probably never will.
> 
> Sad, 


Well I found this interesting thread about :

http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/

It looks like the QST SDK already exists and is planned to be released..
(  http://software.intel.com/en-us/forums/manageability-software-development/topic/54851/reply/74068/ )

> 
> Best regards,
> 	Maxim Levitsky
> 

Gabriel

