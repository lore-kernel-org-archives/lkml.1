Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZHGN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZHGN7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZHGN7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:59:41 -0400
Received: from pan.madism.org ([88.191.52.104]:44904 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZHGN7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:59:40 -0400
Date: Fri, 7 Aug 2009 15:59:39 +0200
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pierre Habouzit <pierre.habouzit@intersec.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: perf-record fix and UI improvement
Message-ID: <20090807135938.GB4844@laphroaig.corp>
References: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
 <1249650066.32113.706.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249650066.32113.706.camel@twins>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:01:06PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-08-07 at 14:15 +0200, Pierre Habouzit wrote:
> > I'm kind of new to the kernel world, so I hope I sent the patches to the
> > proper persons.
> 
> You did well for a first time ;-)

Well, sending patches is not really a first time, I kind of wrote most
of util/strbuf.[hc] and util/parse-options.[hc] ;)


> The things you can improve for next time are:
> 
>  - placing these nice descriptions you made above into the patches
> themselves, as esp the first patch has an empty changelog.

Right.

>  - get your email right :-)

*blush*

> Anyway, I think Ingo already fixed that up for you, so
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Wonderful, thanks.

-- 
Intersec <http://www.intersec.com>
Pierre Habouzit <pierre.habouzit@intersec.com>
Tél : +33 (0)1 5570 3346
Mob : +33 (0)6 1636 8131
Fax : +33 (0)1 5570 3332
37 Rue Pierre Lhomme
92400 Courbevoie
