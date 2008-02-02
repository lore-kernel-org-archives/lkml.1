Return-Path: <linux-kernel-owner+w=401wt.eu-S935437AbYBBUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437AbYBBUyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbYBBUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:54:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58762 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763769AbYBBUyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:54:24 -0500
Date: Sat, 2 Feb 2008 21:54:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Paul.Clements@steeleye.com, nbd-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow NBD to be used locally
Message-ID: <20080202205443.GD31621@elf.ucw.cz>
References: <1201872332265-git-send-email-Laurent.Vivier@bull.net> <20080202112336.GB5362@elf.ucw.cz> <1201965971.4591.13.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201965971.4591.13.camel@frecb07144>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This patch allows Network Block Device to be mounted locally.
...
> Correct. The patch improves the NBD behavior even if it is not perfect.
> And I think if no other page can be freed your system is in very bad
> move ;-)

So the description should be 

"This patch lowers probability of deadlock if you mount  Network Block Device locally"

Hmm.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
