Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbXG1Ulw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbXG1Ulw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXG1Ulo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:41:44 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:32843 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbXG1Ulo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:41:44 -0400
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200707282041.l6SKfgM8000387@wildsau.enemy.org>
Subject: Re: kernel panic w/ 2.6.22.1, VIA EPIA Mini ITX
In-Reply-To: <200707282104.31989.alistair@devzero.co.uk>
To: linux-kernel@vger.kernel.org
Date: Sat, 28 Jul 2007 22:41:39 +0200 (MET DST)
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Checked the RAM on the box? Kinda weird if you're getting VRAM corruption, I 
> wonder if this is due to the RAM failing at the point where the framebuffer 
> is mapped?

you are probably right... I removed one of the RAMs, no crash
anymore. This is not ... nice. The manual says, that the board can
handle up to 1GB (2x512MB). I don't think the RAM itself is damaged --
these are brandnew Kingston "ValueRam" PC133 SD-RAMs with lifelong 
guarantee. I wonder if this behaviour only apperas with my particular
board, or if all VIA EPIA Mini ITX 500 are affected (I've run out
of boards to test ...)

thanks,
herp

> Try running memtest86 on it.

good idea.

