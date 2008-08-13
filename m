Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYHMIFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYHMIFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHMIFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:05:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52308 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbYHMIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:05:01 -0400
Date: Wed, 13 Aug 2008 10:06:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.26: thinkpad x60 is cooled passively
Message-ID: <20080813080618.GA16061@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While verifying that -rc2 regression is gone, I noticed alarming
stuff:

1) thinkpad x60 relies on passive cooling. You have nice 1.8GHz cpu,
which goes away as soon as you load it.

2) after some time it decides that 100% cpu in 1.0GHz is fine for you,
and it takes quite long to recover.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
