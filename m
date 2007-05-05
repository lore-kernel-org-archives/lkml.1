Return-Path: <linux-kernel-owner+w=401wt.eu-S1031791AbXEEPgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031791AbXEEPgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031804AbXEEPgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:36:08 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:1029 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031791AbXEEPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:36:06 -0400
Message-ID: <463C605A.6000305@debianpt.org>
Date: Sat, 05 May 2007 11:45:46 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: 2.6.21-ck1
References: <200705042301.01305.kernel@kolivas.org>
In-Reply-To: <200705042301.01305.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> This patchset is designed to improve system responsiveness and interactivity. 
> It is configurable to any workload but the default -ck patch is aimed at the 
> desktop and -cks is available with more emphasis on serverspace.
> 
> Apply to 2.6.21
> http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-ck1/patch-2.6.21-ck1.bz2
> 

Hi all,

  i am using this patch for the first time and i am reporting my experience.

   Before this patch with all the programs i usually keep running 
(opera/iceweasel with lots of tabs, icedove mail client, konversation 
irc client, akregator feed reader, and the super-hog second life client, 
vim, among others) the reponse was a bit slugish (waiting for program 
focus, wait for redrawing specially when i change from one virtual 
desktop to another).

   After I started using this patch the response/interactivity seems 
improved and faster, i never used Linux so responsive as now. I can 
switch between virtual desktops with immediate response. Even with a 
load of 2.0 (now, while i am writing this) thse system it's very 
responsive and the audio and video still work without glitches.

Just for the record, and if it matters i am using it on a laptop with a 
T2500 CPU, 1 GB RAM.

If there's any way i can help, providing data, running any kind of 
benchmark to quantify the beahaviour, etc... please ask.



Thanks all who made/tested this patch. Good work. Thanks.



[...]

> 
> 乾杯 
> 


-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
