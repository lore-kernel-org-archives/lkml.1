Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbXFEKmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbXFEKmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764011AbXFEKmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:42:24 -0400
Received: from aun.it.uu.se ([130.238.12.36]:50166 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764033AbXFEKmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:42:23 -0400
Date: Tue, 5 Jun 2007 12:41:44 +0200 (MEST)
Message-Id: <200706051041.l55AfiHD025993@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: david@dgreaves.com, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.22-rc4
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 10:29:43 +0100, David Greaves wrote:
> Linus Torvalds wrote:
> > [Linus' 2.6.22-rc4 announcement]
>
> Compile warnings and a new regression: hang on boot during sata_promise
> detection... :(

Please give us some details about your sata_promise problem:
- describe your hardware (Promise chip version, mainboard, chipset, etc)
- which was the last kernel version prior to 2.6.22-rc4 that worked
- the kernel messages up to the hang, if you can capture them
