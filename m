Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYJIJTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYJIJTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYJIJTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:19:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44717 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYJIJTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:19:30 -0400
Date: Thu, 9 Oct 2008 11:19:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz, sbrabec@suse.cz
Subject: 2.6.27-rc8 regression on arm: kernel will no longer boot on Sharp Zaurus c-3000
Message-ID: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...unfortunately, its kind of hard to debug, as I'm testing kernels
using kexec and only see messages late in boot. 2.6.26 works ok.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
