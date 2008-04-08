Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYDHJPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYDHJPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYDHJO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:14:57 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33067 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYDHJO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:14:56 -0400
Date: Tue, 8 Apr 2008 12:14:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: andy@greyhouse.net, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Message-ID: <20080408091414.GA24893@cs181133002.pp.htv.fi>
References: <200804071459.35628.rjw@sisk.pl> <alpine.LNX.1.10.0804080459100.17722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0804080459100.17722@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 05:03:07AM +0200, Jan Engelhardt wrote:
> 
> On Monday 2008-04-07 14:59, Rafael J. Wysocki wrote:
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10323
> >Subject		: panic using bridging on linus kernel 2.6.25-rc6
> >Submitter	: Andy Gospodarek <andy@greyhouse.net>
> >Date		: 2008-03-25 11:40 (14 days old)
> 
> >From BZ:
> 
> 	“It looks like 2.6.24 is good, I guess I'll start bisecting....”
> 
> there have been two bridge-related patches between v2.6.24-rc6..v2.6.24:
> 
>   2dc2f20... [NETFILTER]: bridge-netfilter: fix net_device refcnt leaks
>   2948d2e... [NETFILTER]: bridge: fix double POST_ROUTING invocation
> 
> Maybe it helps to try 2dc.
> Not anymore a 2.6.25-rc issue it seems?

You seem to be confused by the fact that the submitter typoed
"2.6.24-rc6" instead of "2.6.25-rc6" in his bug report?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

