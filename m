Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZGNJZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZGNJZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZGNJZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:25:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39116 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZGNJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:25:08 -0400
Date: Tue, 14 Jul 2009 11:24:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc2: X stop accepting keystrokes?
Message-ID: <20090714092459.GA2010@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...it happened second time now.  In one case, ctrl-alt-backspace
helped and I got at least console back, in the other case I had to
reboot using sysrq.

...hmm. It was probably same crash, because console switching has
probably been locked by X, and I have just one console. I ended up on
empty console before.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
