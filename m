Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbZI3MHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbZI3MHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZI3MHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:07:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47153 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZI3MHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:07:02 -0400
Date: Wed, 30 Sep 2009 14:06:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: 2.6.32-rc1: spitz boots but suspend/resume is broken
Message-ID: <20090930120655.GG1412@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

matrix keyboard driver needs to be enabled, otherwise it seems ok.

Unfortunately, it does not respond to power button in any visible way
:-(. Any ideas what might be wrong/how to debug it?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
