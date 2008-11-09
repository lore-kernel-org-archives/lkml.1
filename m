Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYKIMiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYKIMiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYKIMig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:38:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34947 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYKIMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:38:36 -0500
Date: Sun, 9 Nov 2008 13:33:35 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.28-rc3: regression, thinkpad x60 will not reboot
Message-ID: <20081109123335.GA1783@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Subject says it pretty much all. No, I do not think I have KVM
enabled:

CONFIG_HAVE_KVM=y

...is the only KVM related option in my .config.

It seems 100% reproducible.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
