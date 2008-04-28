Return-Path: <linux-kernel-owner+w=401wt.eu-S934296AbYD1N32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296AbYD1N32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763103AbYD1N3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:29:20 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:59878 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762680AbYD1N3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:29:20 -0400
Date: Mon, 28 Apr 2008 15:28:59 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Tadeusz Gozdek <linux_fan@o2.pl>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Fwd: [PATCH] [MMC] fix clock problem in PXA255/270
Message-ID: <20080428152859.05efccf7@mjolnir.drzeus.cx>
In-Reply-To: <441f2104.26c7abf7.48157da1.e45c7@o2.pl>
References: <441f2104.26c7abf7.48157da1.e45c7@o2.pl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 09:32:49 +0200
Tadeusz Gozdek <linux_fan@o2.pl> wrote:

> It solves the problems with clock in the PXA255/270 MMC/SD hardware.
> This solution was testes with our devices and works good.
> Kernel 2.6.24.4 (but should work with >=2.6.19)
> 

What issue is this supposed to solve?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
