Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXD1Km2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXD1Km2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXD1Km1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:42:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4715 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754776AbXD1KmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:42:17 -0400
Date: Sat, 28 Apr 2007 10:42:06 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Power Management: use mutexes instead of semaphores
Message-ID: <20070428104205.GD7479@ucw.cz>
References: <20070427083857.GB4213@traven> <20070427084322.GC4213@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427084322.GC4213@traven>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> the Power Management code uses semaphores as mutexes. use the mutex
> API instead of the (binary) semaphores
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Looks okay at a quick scan.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
