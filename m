Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZGONQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZGONQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZGONQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:16:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36639 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZGONQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:16:17 -0400
Date: Wed, 15 Jul 2009 15:16:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, jikos@suse.cz
Subject: [regression] Re: 2.6.31-rc2: X stop accepting keystrokes?
Message-ID: <20090715131611.GB2367@elf.ucw.cz>
References: <20090714092459.GA2010@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714092459.GA2010@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ...it happened second time now.  In one case, ctrl-alt-backspace
> helped and I got at least console back, in the other case I had to
> reboot using sysrq.
> 
> ...hmm. It was probably same crash, because console switching has
> probably been locked by X, and I have just one console. I ended up on
> empty console before.

It happened four times now. It seems to happen when I type heavily. I
was once able to reproduce it by hitting keys heavily/randomly.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
