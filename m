Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbZAGQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbZAGQmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbZAGQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:42:43 -0500
Received: from lucidpixels.com ([75.144.35.66]:42459 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760279AbZAGQmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:42:43 -0500
Date: Wed, 7 Jan 2009 11:42:40 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dan Williams <dan.j.williams@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: Status/support for Linux HECI from Intel? (for temp/voltage
 monitoring)
In-Reply-To: <4964DB3E.6080908@intel.com>
Message-ID: <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan> <4964DB3E.6080908@intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Dan Williams wrote:

> Justin Piszcz wrote:
>> The HECI interface would allow lm_sensors developers to grab the
>> temperatures off the chips on the board.
>> 
>> From 2005(?)-2008 there was some chatter about supporting it but it never
>> seemed to happen, is there any eventual planned support for supporting
>> Intel's HECI interface or if the user wants to see the
>> temperatures/voltages just buy a different motherboard with an ITE I/O
>> controller?
>> 
>> I have a couple DG965WH boards and it would be nice to see the
>> temperature of the chipset etc without having to reboot into the BIOS.
>> 
>
> Hi Justin,
>
> I am not up to date on the progress in this area, but perhaps this site 
> (http://www.openamt.org/) has what you are looking for?
>
> Regards,
> Dan
>

Yeah that is the site-- however, will it ever get merged?  I have not 
heard anything about it for a year or so.

Justin.
