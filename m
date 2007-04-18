Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbXDREkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbXDREkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXDREkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:40:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXDREkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:40:46 -0400
Message-ID: <46259E18.6010003@zytor.com>
Date: Tue, 17 Apr 2007 21:27:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Alain.Knaff@poboxes.com
Subject: Re: floppy.ko
References: <200704170036.00605.gene.heskett@verizon.net> <4624CECD.2070805@zytor.com> <200704172312.49787.gene.heskett@gmail.com>
In-Reply-To: <200704172312.49787.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Tuesday 17 April 2007, H. Peter Anvin wrote:
>> Gene Heskett wrote:
>>> I have the usual fd0, a 3.5" 1.44 drive, and fd1, a 5.25" 720k drive in
>>> this machine, both are enabled in the bios with the correct types being
>>> set there.
>> A 5.25" 720k drive?!  That's not a PC standard drive -- 5.25" came in
>> 180K, 360K and 1200K varieties, whereas 3.5" came in 720K, 1440K and
>> 2880K varieties (not including superfloppies.)
>>
>> 	-hpa
> 
> It sure is a std drive, Peter, although many of the later ones that were set 
> up as 1.2 megger's by the pc crowd who have access to a 500 kilobaud 
> controller, could have the 360 rpm spindle jumper'd back to 300 rpm, and when 
> fed with a 250 kilobaud controller (WD177x/277x/279x family, which includes 
> the Fujitsu MB8877), they are perfect 720k devices and are spec'ed that way 
> by the makers.  Many of the older full height Tandon 100-4's could also step 
> quite a few tracks closer to the spindle & I ran them as 765k drives by using 
> 84 tracks.  I even have a chinon that will make 86 tracks most of the time.
> 
> These were all quite common in the middle '80's.  Before your time I suspect.
> 

I know they were quite common, but they were not a standard *PC* 
accessory.  (FWIW, 1200K PC drives could also read/write 720K, which 
allowed you to use non-HD-rated media.)

(And no, this wasn't "before my time".)

	-hpa
