Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZKILL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZKILL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZKILL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:11:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41696 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZKILL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:11:58 -0500
Date: Mon, 9 Nov 2009 12:11:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: htc dream: attempts at mmc and framebuffer support
Message-ID: <20091109111154.GB8750@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried to get mmc and framebuffer to work, but could not. framebuffer
probably needs clock framework to work properly...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
