Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXBVBNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXBVBNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXBVBNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:13:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58670 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXBVBNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:13:21 -0500
Date: Thu, 22 Feb 2007 01:13:15 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Alex Romosan <romosan@sycorax.lbl.gov>
cc: Richard Purdie <rpurdie@rpsys.net>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
In-Reply-To: <87fy8z6pdd.fsf@sycorax.lbl.gov>
Message-ID: <Pine.LNX.4.64.0702220112440.17121@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com>
 <20070219000412.acad13de.akpm@linux-foundation.org>
 <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov>
 <1172097718.5790.29.camel@localhost.localdomain> <87fy8z6pdd.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Richard Purdie <rpurdie@rpsys.net> writes:
> 
> > If FB_RADEON_BACKLIGHT wasn't set for 2.6.20, can you try 2.6.21-rc1
> > with that option disabled?
> 
> i don't have my laptop with me but i am pretty sure
> FB_RADEON_BACKLIGHT wasn't set for 2.6.20 (i think it showed up as a
> new option when i did make oldconfig). i'll post the difference when i
> get home tonight and also try disabling it.

Correct. You need to enable the backlight for the radeon card.
