Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXCTPdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXCTPdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbXCTPdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:33:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34690 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933955AbXCTPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:33:38 -0400
Date: Tue, 20 Mar 2007 16:33:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: vojtech@suse.cz, dmitry.torokhov@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: strange keyboard lag after suspend testing
Message-ID: <20070320153332.GA5533@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
like someone added 50..100msec delay somewhere in keyboard
handling. Mouse does not seem affected. /proc/interrupts seem to
increase as they should, for both keyboard and mouse. Can someone
reproduce it? Any ideas how to debug it?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
