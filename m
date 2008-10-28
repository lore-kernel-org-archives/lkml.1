Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYJ1UMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYJ1UMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYJ1UML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:12:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41430 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYJ1UMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:12:10 -0400
Date: Tue, 28 Oct 2008 21:13:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org,
       penberg@cs.helsinki.fi
Subject: w35und driver now in mainline/staging
Message-ID: <20081028201342.GA17362@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Just... the w35und driver is now in mainline, and works (well enough
to ssh over that; but I guess channel is hardcoded).

Big thanks go to Pekka J Enberg for great cleanups.

Testers are needed; its easy, just grab latest 2.6.28-rc2, enable
staging, enable w35und... and more testing would be helpful.

BTW does anyone know the  name of the chip used in w35und? Or the
names of the finished cards? Something should go to the Kconfig help...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
