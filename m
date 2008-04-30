Return-Path: <linux-kernel-owner+w=401wt.eu-S1765002AbYD3VeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765002AbYD3VeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759952AbYD3VeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:34:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42765 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbYD3VeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:34:16 -0400
Date: Wed, 30 Apr 2008 23:34:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: dmitri.vorobiev@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove NexGen support (fwd)
Message-ID: <20080430213457.GD18536@elf.ucw.cz>
References: <20080429081729.GA3921@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429081729.GA3921@ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It is claimed that NexGen CPUs were never shipped:
> 
> http://lkml.org/lkml/2008/4/20/179
> 
> Also, the kernel support for these chips has been broken for
> a long time, the code intended to support NexGen thereby being
> essentially dead.

Are you sure it never shipped? Wikipedia seems to suggest it did ship.

http://www.cpu-info.com/index2.php?mainid=Nx586&page=5

...FPU for nexgen was never shipped, that implies that CPU did ship.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
