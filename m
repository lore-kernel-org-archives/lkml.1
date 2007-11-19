Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXKSVAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXKSVAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXKSU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:59:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34246 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751244AbXKSU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:59:57 -0500
Date: Mon, 19 Nov 2007 20:10:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc3: find complains about /proc/net
Message-ID: <20071119191000.GA1560@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I think that this worked before:

root@amd:/proc# find . -name "timer_info"
find: WARNING: Hard link count is wrong for ./net: this may be a bug
in your filesystem driver.  Automatically turning on find's -noleaf
option.  Earlier results may have failed to include directories that
should have been searched.
root@amd:/proc#

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
