Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZC2NjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZC2NjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZC2NjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:39:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59403 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZC2NjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:39:09 -0400
Date: Sun, 29 Mar 2009 15:39:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: sleep on sharp zaurus sl-3000 (spitz)
Message-ID: <20090329133901.GA26557@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2.6.29 is pretty good kernel for zaurus: it boots, and bluetooth works
so that I can connect to the network. Unfortunately sleep does not
work, or rather it sleeps but does not wake up.

Unfortunately, I had enough trouble getting zaurus to boot, so I do
not know when the breakage started... nor how to fix it. Any ideas?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
