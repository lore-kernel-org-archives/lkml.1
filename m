Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYKEO1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYKEO1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYKEO1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:27:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45978 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754062AbYKEO1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:27:17 -0500
Date: Wed, 5 Nov 2008 15:23:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081105142329.GA1724@ucw.cz>
References: <20081031150601.GA1457@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031150601.GA1457@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-10-31 16:06:01, Pavel Machek wrote:
> Hi!
> 
> ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
> the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
> compile, so bisect is quite hard to do. Any ideas?

It is still there in -rc3... And yes, it is a regression from 2.6.27.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
