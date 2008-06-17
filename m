Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYFQOQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYFQOQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYFQOQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:16:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:18029 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757941AbYFQOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:16:09 -0400
Date: Tue, 17 Jun 2008 18:16:07 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: toughen get_ro() and get_cd() return values
Message-ID: <20080617141607.GA2712@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080523154204.GA19803@polina.dev.rtsoft.ru> <200806031207.49843.marc.pignat@hevs.ch> <20080605144310.GA31596@polina.dev.rtsoft.ru> <200806051759.00202.marc.pignat@hevs.ch> <20080605171013.GA10513@polina.dev.rtsoft.ru> <20080614163640.01e89c51@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080614163640.01e89c51@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 04:36:40PM +0200, Pierre Ossman wrote:
> On Thu, 5 Jun 2008 21:10:13 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > 
> > Pierre, I see you didn't yet pushed out the mmc tree, so.. would you
> > prefer this patch folded into 0/3 series and resent?
> > 
> 
> This works fine. :)

Great, patches follows. Also added missing changes for the at91_mci host.
Now, I hope, every host is really converted.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
