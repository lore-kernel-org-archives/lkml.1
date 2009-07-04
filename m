Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZGHKed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZGHKed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZGHKe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:34:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51832 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZGHKeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:34:25 -0400
Date: Sat, 4 Jul 2009 04:44:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com
Subject: 2.6.31-rc1: zaurus suspend regressing
Message-ID: <20090704024416.GA1345@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 2.6.30, spitz suspended with PSPR fix + charging disabled.

In 2.6.31-rc1, PSPR fix is in, but suspend does not work, not even
with charging disabled.

Any ideas?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
