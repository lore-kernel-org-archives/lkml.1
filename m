Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbXE0VRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbXE0VRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbXE0VR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:17:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1683 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757327AbXE0VR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:17:28 -0400
Date: Sun, 27 May 2007 21:17:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Greaves <david@dgreaves.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070527211718.GH3989@ucw.cz>
References: <4658B7DD.3060309@tmr.com> <4659442E.2060307@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4659442E.2060307@dgreaves.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Personally I think the kernel suspend should write a signature - similar to a
> hash of the bzImage - into the suspend image so it won't even attempt a resume
> if there's a mismatch. (Yes, I made this mistake once whilst playing with suspend).

We have such 'hash' but it is not foolproof. Improvements welcome.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
