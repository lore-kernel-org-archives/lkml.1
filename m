Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYH0O76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYH0O76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYH0O7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:59:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43427 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYH0O7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:59:50 -0400
Date: Wed, 27 Aug 2008 17:02:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Andi Kleen <andi@firstfloor.org>, jassi brar <jassi_singh_brar@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
Message-ID: <20080827150221.GV26610@one.firstfloor.org>
References: <20080827074751.GO26610@one.firstfloor.org> <35042.98883.qm@web33207.mail.mud.yahoo.com> <20080827124734.GT26610@one.firstfloor.org> <1219848575.9776.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219848575.9776.8.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 04:49:35PM +0200, Kasper Sandberg wrote:
> On Wed, 2008-08-27 at 14:47 +0200, Andi Kleen wrote:
> > >  As far as features are concerned, please suggest me what could be done with /dev/loop0 and not for /dev/vblk?
> > 
> > Serious question?  cryptoloop, offsets are the big ticket items,
> > i'm sure there are more.
> 
> As far as cryptoloop goes, isnt that obsoleted anyway? 

It's like saying: FAT -- isn't that obsolete by now? 
As long as there are crypto loop files around it's not obsolete.

> is there anyone
> that doesent use dm-crypt by now?

Wrong question. You lose.

-Andi
