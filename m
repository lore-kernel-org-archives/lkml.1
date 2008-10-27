Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYJ0TWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYJ0TWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYJ0TWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:22:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39920 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYJ0TWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:22:04 -0400
Date: Mon, 27 Oct 2008 20:20:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Soeren Sonnenburg <kernel@nn7.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tomas.winkler@intel.com, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027192057.GJ22217@kernel.dk>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost> <1225132278.3796.32.camel@johannes.berg> <1225133082.3796.35.camel@johannes.berg> <20081027190011.GA3951@localhost.aei.mpg.de> <20081027190631.GG22217@kernel.dk> <1225134571.3796.41.camel@johannes.berg> <20081027191307.GI22217@kernel.dk> <1225135018.3796.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225135018.3796.49.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27 2008, Johannes Berg wrote:
> On Mon, 2008-10-27 at 20:13 +0100, Jens Axboe wrote:
> 
> > If you want something else tested, just let me know. I don't care a
> > whole lot about how it gets fixed, as long as it does :-). I use STR
> > heavily, so it's quite a burden to have it broken.
> 
> I don't really know. Like I said to Carlos, figuring out which of the
> functions called from set_disassoc hangs would be useful, but you'd
> probably want to coordinate with him so you don't both do it. Or if you
> both do, it'd confirm it twice ;)

OK, I can try and do that tomorrow when I'm at the desktop again, I have
the dock there serial console.

-- 
Jens Axboe

