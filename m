Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZJVHFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZJVHFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZJVHF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:05:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36985 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZJVHF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:05:29 -0400
Date: Thu, 22 Oct 2009 09:05:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Andrew Morton <akpm@osdl.org>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Subject: Re: spitz backlight: fix brightness limiting
Message-ID: <20091022070527.GE2211@elf.ucw.cz>
References: <20091019213751.GC1482@ucw.cz>
 <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-22 04:20:34, Eric Miao wrote:
> It's a little bit weird it's called 'limit_mask' when I first converted it
> to a spi driver. There must be some reasons, Richard, you've got
> any ideas?

Yes, the code was "interesting"...

I can certainly do the rename, but maybe we can fix the issue now and
do futher cleanups later?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
