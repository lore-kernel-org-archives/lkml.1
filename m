Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYLDKyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYLDKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYLDKyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:54:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51272 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYLDKyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:54:00 -0500
Date: Thu, 4 Dec 2008 11:55:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, mchan@broadcom.com
Subject: bnx2: fs_sync_timeout, reset code = 1020002
Message-ID: <20081204105550.GA2429@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm getting `subj` (with different numbers, 1020002, 1020004,
sometimes 102006). ifconfig eth0 up fails, network is completely
broken.

Devices are 14e4:1639... Any hints/ideas? (It is possible this is
broken hardware).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
