Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbXF2K3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbXF2K3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 06:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXF2K3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 06:29:10 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49627 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbXF2K3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 06:29:09 -0400
Message-ID: <4684DEF3.5060103@drzeus.cx>
Date: Fri, 29 Jun 2007 12:29:07 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Midhun Agnihotram <agnimidhun@gmail.com>
CC: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Mounting MMC card
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>	 <200706282210.23770.hjk@linutronix.de>	 <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>	 <200706291038.58358.hjk@linutronix.de>	 <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>	 <4684CDCC.9030202@drzeus.cx>	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>	 <4684D358.9090402@drzeus.cx> <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
In-Reply-To: <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Midhun Agnihotram wrote:
>>
>> This all looks correct. How about /proc/partitions? And what's in
>> /sys/block?
>>
> 
> Both of them show no sign of MMC.
> 

Then you cannot mount them. What output did you see in dmesg when you inserted
the card?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
