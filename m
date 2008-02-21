Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbYBUNGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbYBUNGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYBUNGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:06:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43082 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754979AbYBUNGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:06:04 -0500
Date: Thu, 21 Feb 2008 14:05:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: make clean does not remove vmlinux.bin.all
Message-ID: <20080221130528.GA20053@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...which is pretty big...

arch/x86/boot/compressed$ du -sh *
16K     relocs
8.4M    vmlinux.bin.all

(note that I'm using separate object/source directories, but it should
not matter here).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
