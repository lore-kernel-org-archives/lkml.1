Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbZARInO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbZARInO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZARIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:42:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34551 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbZARIm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:42:57 -0500
Date: Sun, 18 Jan 2009 09:42:48 +0100
From: Pavel Machek <pavel@suse.cz>
To: Tomas Szepe <szepe@pinerecords.com>
Cc: arodland@noln.com, jbglaw@lug-owl.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Morse code panics for 2.6.29-rc1
Message-ID: <20090118084248.GD1944@ucw.cz>
References: <20090111190503.GA20861@louise.pinerecords.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111190503.GA20861@louise.pinerecords.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-11 20:05:03, Tomas Szepe wrote:
> Bumped into this silly thing (morse code panics) by accident after
> 6 years or so, and couldn't resist updating it for a recent kernel.
> So, here goes, enjoy.
> 
> Patch against 2.6.29-rc1.

Add a signed-off-by and try to merge it. Slightly crazy, but it is
more useful than just blinking leds... 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
