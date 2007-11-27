Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXK0F5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXK0F5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXK0F5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:57:08 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:36816 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXK0F5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:57:07 -0500
Date: Tue, 27 Nov 2007 06:57:03 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] mmc: Add missing sg_init_table() call
Message-ID: <20071127065703.63fea228@poseidon.drzeus.cx>
In-Reply-To: <20071126212955.07f65b0d.akpm@linux-foundation.org>
References: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
	<20071126212955.07f65b0d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 21:29:55 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Pierre, I can queue this up but if you merge it into your tree I shall drop
> it and shall lose track of it.  So it's then all down to you to remember to
> get the fix into 2.6.24.
> 
> (Except this particular bug looks like a post-2.6.23 regression, so I can cc
> the Rafael which never forgets, so it will then get tracked all the way into
> Linus's tree)
> 

Jens said he applied it, so I figured the issue was handled. Jens, what happened to it?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
