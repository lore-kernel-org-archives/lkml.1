Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbXBUXw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbXBUXw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXBUXw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:52:28 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:3846 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbXBUXw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:52:27 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
References: <20070219044616.GC25659@washoe.onerussian.com>
	<20070219000412.acad13de.akpm@linux-foundation.org>
	<1171876788.6046.3.camel@localhost.localdomain>
	<877iub9mu2.fsf@sycorax.lbl.gov>
	<1172097718.5790.29.camel@localhost.localdomain>
Date: Wed, 21 Feb 2007 15:51:42 -0800
In-Reply-To: <1172097718.5790.29.camel@localhost.localdomain> (message from
	Richard Purdie on Wed, 21 Feb 2007 22:41:57 +0000)
Message-ID: <87fy8z6pdd.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie <rpurdie@rpsys.net> writes:

> If FB_RADEON_BACKLIGHT wasn't set for 2.6.20, can you try 2.6.21-rc1
> with that option disabled?

i don't have my laptop with me but i am pretty sure
FB_RADEON_BACKLIGHT wasn't set for 2.6.20 (i think it showed up as a
new option when i did make oldconfig). i'll post the difference when i
get home tonight and also try disabling it.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
