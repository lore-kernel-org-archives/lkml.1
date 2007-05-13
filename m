Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXENKgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXENKgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXENKgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:36:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2040 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756026AbXENKgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:36:06 -0400
Date: Sun, 13 May 2007 19:36:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Vladimir Pouzanov <farcaller@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI Power Down is broken in 2.6.21.1
Message-ID: <20070513193643.GA3969@ucw.cz>
References: <loom.20070508T175303-27@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20070508T175303-27@post.gmane.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have got a problem with Asus F3T notebook and 2.6.21.1 kernel. When I
> perform powerdown (with user-space app or alt+sysrq+o) I get "Power Down."
> message, but the notebook doesn't turn off. Everything is ok on 2.6.20.
> 
> There seem to be no changes in acpi/sleep/poweroff.c so I don't know where
> should I start looking for a bug.
> 
> F3T is based on Thrion64 X2 CPU (I'm running it in x86 mode with SMP and
> PREEMPT).

bugzilla.kernel.org; intel acpi people actually watch it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
