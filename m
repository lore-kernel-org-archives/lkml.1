Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbXEUWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbXEUWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbXEUWUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:20:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41219 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756673AbXEUWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:20:17 -0400
Date: Tue, 22 May 2007 00:20:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [patch 00/69] -stable review
Message-ID: <20070521222004.GT6291@stusta.de>
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070521123148.a3dad5f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 12:31:48PM -0700, Andrew Morton wrote:
> On Mon, 21 May 2007 12:16:12 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > This is the start of the stable review cycle for the 2.6.21.2 release.
> 
> Gee a lot of these are fixing recently-added regressions :(
>...

If only it would fix all of them...

Michal's list [1] currently contains 51 different regressions in
2.6.21 compared to 2.6.20 (12 of them were already reported before
2.6.21 was released).

cu
Adrian

[1] http://kernelnewbies.org/known_regressions [2]
[2] the 2.6.21 regressions are listed after the 28 known 2.6.22-rc 
    regressions

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

