Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYCENoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYCENoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYCENnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:43:51 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:35922 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYCENnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:43:50 -0500
Date: Wed, 5 Mar 2008 14:42:05 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305144205.7a9971bc@mjolnir.drzeus.cx>
In-Reply-To: <20080305090304.GA10053@elf.ucw.cz>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
	<20080305070201.0d16cd40@mjolnir.drzeus.cx>
	<20080305094023.6486ebdf@mjolnir.drzeus.cx>
	<20080305090304.GA10053@elf.ucw.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008 10:03:04 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> 
> Actually, there are more uncertaininties. Suspecting some machines
> seemed to produce noise whenever they were in low-power state. Not
> with fluctuations: when I forced them to low-power, it just produced
> steady beep.
> 

Ouch. How do I quickly test that here?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
