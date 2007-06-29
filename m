Return-Path: <linux-kernel-owner+w=401wt.eu-S1763158AbXF2LLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763158AbXF2LLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXF2LLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:11:01 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44650 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721AbXF2LLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:11:01 -0400
Message-ID: <4684E8C2.7050109@drzeus.cx>
Date: Fri, 29 Jun 2007 13:10:58 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Midhun Agnihotram <agnimidhun@gmail.com>
CC: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Mounting MMC card
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>	 <200706291038.58358.hjk@linutronix.de>	 <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>	 <4684CDCC.9030202@drzeus.cx>	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>	 <4684D358.9090402@drzeus.cx>	 <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>	 <4684DEF3.5060103@drzeus.cx>	 <4dde4acb0706290357x54d3ea32vaf75d5cfe638cb25@mail.gmail.com>	 <4684E65F.2070202@drzeus.cx> <4dde4acb0706290406v204fb87eif0e5fbae17636593@mail.gmail.com>
In-Reply-To: <4dde4acb0706290406v204fb87eif0e5fbae17636593@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Midhun Agnihotram wrote:
>>
>> Not likely. It's probably a no-op when you don't have devfs.
>>
> 
>   CONFIG_MMC_DEBUG is already enabled. This is not printing any debug
> statements as such.
> 

Then something is seriously broken with your kernel. I can only assume that this
is because of some vendor modifications. So I would suggest contacting them or
trying to get a vanilla kernel running.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
