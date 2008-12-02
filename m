Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYLBMAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYLBMAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYLBMAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:00:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52419 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYLBMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:00:34 -0500
Date: Tue, 2 Dec 2008 13:02:24 +0100
From: Pavel Machek <pavel@suse.cz>
To: mtk.manpages@gmail.com, linux-doc@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
Cc: gp@novell.com, fnadge@suse.cz
Subject: clock_gettime not mentioned in time.7
Message-ID: <20081202120223.GA4753@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

man 7 time does not mention clock_gettime() (and concept of monotonic
time at all). I guess it should... at least clock_gettime() should be
mentioned in "SEE ALSO".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
