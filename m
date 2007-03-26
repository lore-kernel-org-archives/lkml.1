Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXCZMwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXCZMwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXCZMwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:52:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2351 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752402AbXCZMwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:52:10 -0400
Date: Mon, 26 Mar 2007 12:51:57 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] clockevents: remove bad designed sysfs support for now
Message-ID: <20070326125157.GC11288@ucw.cz>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <1174900868.4182.21.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174900868.4182.21.camel@chaos>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-03-26 11:21:08, Thomas Gleixner wrote:
> The current sysfs support of clockevents does not obey the "only one
> value per file" rule.
> 
> The real fix is not 2.6.21 material. Therefor remove the sysfs support
> for now.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
