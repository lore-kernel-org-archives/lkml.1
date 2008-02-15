Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbYBOX7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbYBOX7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbYBOX64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:58:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2645 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757627AbYBOX6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:58:55 -0500
Date: Fri, 15 Feb 2008 23:58:42 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Message-ID: <20080215235842.GA5190@ucw.cz>
References: <200802111623.38478.elendil@planet.nl> <200802130941.47163.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802130941.47163.elendil@planet.nl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In general 2.6.25 if looking quite good on my desktop, but there's one
> > important issue: the system no longer powers off after shutdown.
> > This works fine with 2.6.24.
> 
> I was wrong :-(
> 
> I'd not really done any real workkkk under 2.6.25 yet, but now while running 
> a kernel compile with -j4 (single processor, dual core Pentium D), I see 
> this behavior. The mouse cursor moves a bit jerky and I sometimes get key 
> presses repeated.

I see this one, too... x60, too...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
