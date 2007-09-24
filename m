Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbXIXQuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbXIXQuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764521AbXIXQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:48:59 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:56883 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763653AbXIXQs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:48:58 -0400
Date: Mon, 24 Sep 2007 18:50:33 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's in mmc.git for 2.6.24
Message-ID: <20070924185033.1aba452e@poseidon.drzeus.cx>
In-Reply-To: <1190627279.5133.123.camel@aeonflux.holtmann.net>
References: <20070924102848.503a8d22@poseidon.drzeus.cx>
	<1190627279.5133.123.camel@aeonflux.holtmann.net>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 11:47:59 +0200
Marcel Holtmann <marcel@holtmann.org> wrote:

> 
> where can I get this driver? I have a bunch of SDIO WiFi cards that
> might contain Libertas chip.
> 

If you just want to determine if they have the chip or not, then just
examine the debug output my current sdio tree spews out. Libertas chips
should have vendor/card 0x02df/0x9103.

> 
> The driver name will be btsdio and I will merge the initial version
> within the 2.4.24 merge window. However this driver will go in via the
> Bluetooth subsystem. My only request is that we can do the MMC merge
> really early in the merge window.
> 

My plan is to do it immediately when Linus says go.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
