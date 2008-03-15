Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYCOPFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYCOPFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 11:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYCOPFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 11:05:10 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:58316 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYCOPFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 11:05:09 -0400
Date: Sat, 15 Mar 2008 16:04:28 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Simon Huggins <huggie@earth.li>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080315160428.6d25b4e0@mjolnir.drzeus.cx>
In-Reply-To: <20080313211749.GN28693@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk>
	<20080302104031.GB3861@ucw.cz>
	<20080303204300.69cbe392@mjolnir.drzeus.cx>
	<20080303203808.GH13869@elf.ucw.cz>
	<20080303220530.49201544@mjolnir.drzeus.cx>
	<20080313211749.GN28693@paranoidfreak.co.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 21:17:49 +0000
Simon Huggins <huggie@earth.li> wrote:

> 
> I'm happy to test bits.  What do I need to do to switch time sources for
> instance?
> 

I'm no expert, but you have the kernel parameter "clocksource" documented in Documentation/kernel-parameters. Also check the directory /sys/devices/system/clocksource for assorted runtime changes.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
