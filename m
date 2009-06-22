Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZFVRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZFVRZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZFVRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:25:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56765 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZFVRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:25:10 -0400
Date: Mon, 22 Jun 2009 19:25:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] lis3: fix typo
Message-ID: <20090622172507.GB21299@elf.ucw.cz>
References: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 15:38:05, Daniel Mack wrote:
> Bit 0x80 in CTRL_REG3 is an ACTIVE_LOW rather than an ACTIVE_HIGH
> function, I got that wrong during my last change.

Whole series looks okay to me, but I did not check the data sheets.

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
