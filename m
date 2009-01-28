Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZA1Lia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZA1Lia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZA1LiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:38:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39194 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZA1LiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:38:17 -0500
Date: Wed, 28 Jan 2009 12:38:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, milan@ucw.cz
Subject: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090128113809.GA29424@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2.6.29-rc1 was great step forward over previous kernels: it not only
displays something on screen but also mounts root
filesystem. Unfortunately it then panics with "attempted to kill
init".

I tried both with CONFIG_EABI=N and  CONFIG_EABI=Y, OABI_COMPAT=Y. Any
more tricks I should try?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
