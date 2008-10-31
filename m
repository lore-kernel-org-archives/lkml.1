Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYJaPZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYJaPZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaPZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:25:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60178 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbYJaPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:25:45 -0400
Date: Fri, 31 Oct 2008 16:06:02 +0100
From: Pavel Machek <pavel@suse.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com
Subject: 2.6.28-rc2-git1: spitz still won't boot
Message-ID: <20081031150601.GA1457@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
compile, so bisect is quite hard to do. Any ideas?

									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
