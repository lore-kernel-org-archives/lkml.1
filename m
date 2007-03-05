Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbXCEDQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbXCEDQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXCEDQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:16:42 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:62030 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXCEDQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:16:41 -0500
Date: Sun, 04 Mar 2007 22:16:29 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <Pine.LNX.4.64.0703041831010.1190@montezuma.windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Zwane Mwaikambo <zwane@infradead.org>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>
Message-id: <200703042216.29618.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703041800.53360.kernel@kolivas.org>
 <200703040911.16845.gene.heskett@gmail.com>
 <Pine.LNX.4.64.0703041831010.1190@montezuma.windriver.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007, Zwane Mwaikambo wrote:
>On Sun, 4 Mar 2007, Gene Heskett wrote:
>> >There will be times when the mainline scheduler feels more
>> > interactive than this scheduler, and that is because it has
>> > significant unfairness granted towards interactive tasks. This
>> > degree of unfairness in an effort to maintain interactivity has been
>> > criticised and causes problems in certain environments with both
>> > loss of fairness, relative starvation and is not entirely
>> > predictable.
>>
>> Well, in 20 minutes of playing, I am so far VERY impressed, the kmail
>> composer is typing to the screen in unison to my keystrokes, where
>> with the older version it often went away for 10 or more seconds at a
>> time, then displayed the last sentence I had typed in one (or 2
>> sometimes) swell foop.  Now I can back up and correct a typo in real
>> time whereas before, it was often faster if the typo was half a line
>> back, and the key repeat so darned slow it was often over a second per
>> character cell moved, to go grab the mouse, position the cursor on the
>> typo, click, wait for the indicator to move, and then fix it.  Typing
>> is now pleasurable again.  Key repeats seem to remain at the set in
>> the bios key repeat speed.  Amazing.  I do believe you have given me
>> back my machine.
>
>What are the specs on your hardware?

XP-2800 Athlon on a biostar board whose model number I've forgotten. 1 GB 
of dual channel 400 mhz ram running at 333 because this athlon falls over 
at 400mhz fsb settings.  480GB of drives in 3 pieces.

Running a jaton 3dForce 6200-256 video card with nvidia driver, which does 
the opengl stuff better than the ati 9200se I took out a week ago, but 
this nvidia card is several times harder on the cpu when tvtime is 
running than the ati was.  There are other cards in this box, 1394, nic, 
usb expander, but that is the main list of power burners.

Its dmesg clock is just short of 2100. and:
Calibrating delay using timer specific routine.. 4177.82 BogoMIPS 
(lpj=2088910)

In comparison to an XP-1400 I had before, this is nowhere near 2x faster.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
