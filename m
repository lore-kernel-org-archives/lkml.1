Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYHGHe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYHGHe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYHGHeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:34:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52953 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYHGHeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:34:18 -0400
Date: Thu, 7 Aug 2008 09:34:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-uvc-devel@berlios.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc2: uvcvideo breaks after suspend to ram
Message-ID: <20080807073416.GA16610@atrey.karlin.mff.cuni.cz>
References: <4899C3CF.1010104@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4899C3CF.1010104@tuffmail.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't use the webcam on my EeePC; I just happened to try it while
> testing 2.6.27-rc2.  I don't know about any other version so this isn't
> neccessarily a regression.
> 
> I think I tested it using Kopete, then later I got this warning on
> resume.  I definitely didn't have Kopete open when I suspended
> though.

Can you try with version originaly shipped with eeepc? I'd expect it
to work there... Maybe they have some patch in it?

									Pavel
> 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
