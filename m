Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXISUlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXISUlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXISUlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:41:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43069 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbXISUlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:41:46 -0400
Date: Wed, 19 Sep 2007 22:43:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Miles Lane <miles.lane@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070919204311.GA4791@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com> <20070918191741.GA27725@uranus.ravnborg.org> <a44ae5cd0709181242j517e39e0xc3f78224bcda360a@mail.gmail.com> <20070918202654.GA27836@uranus.ravnborg.org> <46F05378.8020907@googlemail.com> <46F055BA.6000705@googlemail.com> <20070919193308.GA4253@uranus.ravnborg.org> <46F18861.80705@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F18861.80705@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Got it. We sometimes get a numm pointer when printing the expression (in expr.c).
> > I have queued following fix.
> > 
> 
> Patch is fine , fixes the problem here.

Thanks for testing.

	Sam
