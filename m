Return-Path: <linux-kernel-owner+w=401wt.eu-S1161325AbXCBKaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161325AbXCBKaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXCBKaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:30:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60285 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933310AbXCBKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:30:09 -0500
Date: Fri, 2 Mar 2007 11:04:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc2: bluetooth hardlocks [regression from -rc1]
Message-ID: <20070302100427.GA2293@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

As soon as I try to start bluetooth connection (gprs over nokia 6230)
on thinkpad x60 (internal bluetooth dongle, connected over usb),
machine hangs. It worked okay in -rc1 (modulo suspend issues).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
