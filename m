Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZFVUpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZFVUpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZFVUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:45:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58001 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFVUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:45:05 -0400
Date: Mon, 22 Jun 2009 22:45:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: torvalds@linux-foundation.org, Greg KH <greg@kroah.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [PATCH] Documentation: add documentation summary for rc-series
	and merge window
Message-ID: <20090622204500.GB24236@elf.ucw.cz>
References: <20090622180438.GG23972@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622180438.GG23972@bombadil.infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 14:04:38, Luis R. Rodriguez wrote:
> This is losely based on previous discussions on linux-kernel [1][2][3].
> Lets also refer people reading the stable rules to
> Documentation/development-process/.
> 
> Also add the number of days it has taken between releases,
> and provide the average for the last 10 releases: 86.0 days.
> 
> [1] http://marc.info/?l=linux-kernel&m=122048427801324&w=2
> [2] http://marc.info/?l=linux-netdev&m=122048757705315&w=2
> [3] http://marc.info/?l=linux-kernel&m=124515657407679&w=2
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
NAK.

> +2.0.2: RC-SERIES RULES
> +
> +This section summarizes what kind of patches are accepted before the merge
> +window closes and after it closes. These patches are targeted for the kernel
> +prior to its final release.
> +
> +The rc-series focus should really be to address regressions.
> +
> +2.0.2.0: RC-SERIES RULES PRIOR TO THE RC1 RELEASE
> +
> +These are the types of patches that will get accepted prior to a kernel rc1 release,
> +during the merge window:
> +
> + - it must fix a regression
> + - it must fix a security hole
> + - it must fix a oops/kernel hang
> +
> +Non-intrusive bug fixes or small fixes will not be accepted. If the
> patch in

What? Prior to rc1, new features are accepted.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
