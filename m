Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYH1KIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYH1KIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYH1KIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:08:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37690 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYH1KId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:08:33 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 06:08:33 EDT
Subject: Re: An idea .... with code
From: Kasper Sandberg <lkml@metanurb.dk>
To: Andi Kleen <andi@firstfloor.org>
Cc: jassi brar <jassi_singh_brar@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080827150221.GV26610@one.firstfloor.org>
References: <20080827074751.GO26610@one.firstfloor.org>
	 <35042.98883.qm@web33207.mail.mud.yahoo.com>
	 <20080827124734.GT26610@one.firstfloor.org>
	 <1219848575.9776.8.camel@localhost>
	 <20080827150221.GV26610@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 11:41:13 +0200
Message-Id: <1219916473.9776.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 17:02 +0200, Andi Kleen wrote:
> On Wed, Aug 27, 2008 at 04:49:35PM +0200, Kasper Sandberg wrote:
> > On Wed, 2008-08-27 at 14:47 +0200, Andi Kleen wrote:
> > > >  As far as features are concerned, please suggest me what could be done with /dev/loop0 and not for /dev/vblk?
> > > 
> > > Serious question?  cryptoloop, offsets are the big ticket items,
> > > i'm sure there are more.
> > 
> > As far as cryptoloop goes, isnt that obsoleted anyway? 
> 
> It's like saying: FAT -- isn't that obsolete by now? 
> As long as there are crypto loop files around it's not obsolete.
I disagree, as i recall, i stopped using cryptoloop and went directly to
dm-crypt with compatibility for my already existing files?

> 
> > is there anyone
> > that doesent use dm-crypt by now?
> 
> Wrong question. You lose.
In the case that i am correct above, it would appear that i did not
loose, given that the newer stuff has backwards compatibility (which i
am fairly certain it does)

also do not forget that i did say its unlikely that loop be removed due
to its heavily "established" status.

> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

