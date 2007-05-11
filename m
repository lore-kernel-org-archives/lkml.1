Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbXEKS7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbXEKS7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXEKS7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:59:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3118 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751698AbXEKS7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:59:25 -0400
Date: Fri, 11 May 2007 13:14:36 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1 -- Hibernation locked up and didn't power down (had to hold power button down for five seconds)
Message-ID: <20070511131436.GG4052@ucw.cz>
References: <a44ae5cd0705071637x59d4579bm369b44c7975bea37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0705071637x59d4579bm369b44c7975bea37@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is probably more log info than you need, but I am 
> including it in
> case it helps.

It is long, but useless, because it misses the critical parts.

> [ 5487.322599] agpgart-intel 0000:00:00.0: LATE freeze
> [ 5487.322711] swsusp: critical section:
> [ 5487.365827] swsusp: Need to copy 122651 pages
> [ 5487.365831] swsusp: Normal pages needed: 114026 + 
> 1024 + 24,
> available pages: 122386

(messages concerning powerdown missing, because they are not in usual
buffers. Capture them somehow. Serial console/digicam/paper and
pencil.

> At this point, I had to hard power down.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
