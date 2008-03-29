Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYC2QcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYC2QcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 12:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYC2QcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 12:32:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2110 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbYC2QcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 12:32:06 -0400
Date: Sat, 29 Mar 2008 17:31:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: USB-audio strange problems
Message-ID: <20080329163154.GA5106@ucw.cz>
References: <20070203131014.GA4231@elf.ucw.cz> <s5htzy0y2rx.wl%tiwai@suse.de> <20080319211247.GA2659@elf.ucw.cz> <s5h63vhver6.wl%tiwai@suse.de> <20080320111637.GB24304@atrey.karlin.mff.cuni.cz> <s5h3aqlvdxe.wl%tiwai@suse.de> <20080320231835.GE17431@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320231835.GE17431@elf.ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Mostly solved now. Device seems to have 5 interfaces, but only 4 of
them work.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
