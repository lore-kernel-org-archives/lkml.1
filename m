Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYCIUQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYCIUQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYCIUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:16:29 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:35594 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYCIUQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:16:27 -0400
Date: Sun, 9 Mar 2008 21:14:28 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080309211428.5d93f042@mjolnir.drzeus.cx>
In-Reply-To: <20080309193009.GD27193@khazad-dum.debian.net>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
	<20080305070201.0d16cd40@mjolnir.drzeus.cx>
	<20080305094023.6486ebdf@mjolnir.drzeus.cx>
	<20080306092730.4412d085@mjolnir.drzeus.cx>
	<20080309151659.63d54f38@mjolnir.drzeus.cx>
	<20080309193009.GD27193@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 16:30:09 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Sun, 09 Mar 2008, Pierre Ossman wrote:
> > I'm beginning to think this is a lost cause. I've tried several variants, all without satisfactory results.
> 
> THIS will work:
> http://www.nordichardware.com/image3.php?id=1446
> 
> ThinkPad owners have known this for a while...
> 

Odd. The thinkpad sites I've been looking at all agree that glue doesn't help at all. Do you have some more info about that "fix"?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
