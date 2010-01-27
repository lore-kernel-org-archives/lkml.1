Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748Ab0A0RNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0A0RNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708Ab0A0RNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:13:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58486 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0A0RNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:13:20 -0500
Date: Wed, 27 Jan 2010 18:13:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: spitz (arm pda): time no longer ok after resume
Message-ID: <20100127171308.GA24875@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems that spitz has problems with time after resume; time while it
was sleeping is not accounted. This seems to be regression in
2.6.33-rc5.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
