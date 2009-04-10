Return-Path: <linux-kernel-owner+w=401wt.eu-S1764918AbZDJKbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918AbZDJKbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZDJKbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:31:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46278 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbZDJKbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:31:34 -0400
Date: Fri, 10 Apr 2009 12:34:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: 2.6.30-rc1: white screen during boot (regression) on spitz
Message-ID: <20090410103429.GA31367@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After update to 2.6.30-rc1, sharp zaurus c-3000 fails to boot with
white screen (with stripes). That's a regression w.r.t. 2.6.29.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
