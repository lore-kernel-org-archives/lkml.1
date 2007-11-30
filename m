Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbXK3Ull@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbXK3Ull (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXK3Ul1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:41:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52736 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbXK3Ul0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:41:26 -0500
Date: Fri, 30 Nov 2007 21:42:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: adaplas@gmail.com, akpm@linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: /sys/class/graphics/fbcon/cursor_blink contains 0 after boot
Message-ID: <20071130204209.GA2243@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


...but cursor is blinking. Smells like a bug to me.

Plus, cursor timer ticks even when cursor is hidden.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
