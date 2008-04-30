Return-Path: <linux-kernel-owner+w=401wt.eu-S1765772AbYD3Vp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765772AbYD3Vp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbYD3VpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:45:14 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:45364 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024AbYD3VpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:45:13 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86: remove NexGen support (fwd)
Date: Wed, 30 Apr 2008 23:45:10 +0200
User-Agent: KMail/1.9.9
Cc: dmitri.vorobiev@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
References: <20080429081729.GA3921@ucw.cz> <20080430213457.GD18536@elf.ucw.cz>
In-Reply-To: <20080430213457.GD18536@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302345.13217.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008 23:34:58 Pavel Machek wrote:
> Hi!
>
> > It is claimed that NexGen CPUs were never shipped:
> >
> > http://lkml.org/lkml/2008/4/20/179
> >
> > Also, the kernel support for these chips has been broken for
> > a long time, the code intended to support NexGen thereby being
> > essentially dead.
>
> Are you sure it never shipped? Wikipedia seems to suggest it did ship.
>
> http://www.cpu-info.com/index2.php?mainid=Nx586&page=5
>
> ...FPU for nexgen was never shipped, that implies that CPU did ship.
>
> 								Pavel

Exactly. Nx686 is the one that was turned into AMD K6.

-- 
Ondrej Zary
