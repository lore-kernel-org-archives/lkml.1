Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbXGOALT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbXGOALT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbXGOALI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:11:08 -0400
Received: from lucidpixels.com ([75.144.35.66]:60595 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbXGOALG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:11:06 -0400
Date: Sat, 14 Jul 2007 20:11:04 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
cc: linux-raid maillist <linux-raid@vger.kernel.org>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: raid5:md3: read error corrected ,  followed by ,  Machine Check
 Exception: .
In-Reply-To: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
Message-ID: <Pine.LNX.4.64.0707142010250.20845@p34.internal.lan>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jul 2007, Mr. James W. Laferriere wrote:

> 	Hello All ,  I was under the impression that a 'machine check' would 
> be caused by some near to the CPU hardware failure ,  Not a bad disk ?
> 	I was also under the impression that software raid s/b a little more 
> resilient than this .
> 	But then maybe one or the other of the subsystems walked all over the 
> other one trying to correct itself .  Who knows .
> 	The below is ALL I'll be able to get .  A log of a previous boot is 
> available at ...
>
> http://www.baby-dragons.com/test-2.6.21.5-mptscsi-4.00.10.00-2007006161326.log

Looks like /dev/sdd is on its way out, repace the drive?  I'm not sure
however why you'd get those MCEs at the end unless you really have bad
CPUs or memory in the system?

Justin.


