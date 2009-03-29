Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZC2Uqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZC2Uqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZC2Uq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:46:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39224
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbZC2Uq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:46:26 -0400
Date: Sun, 29 Mar 2009 13:46:14 -0700 (PDT)
Message-Id: <20090329.134614.198823811.davem@davemloft.net>
To: pablo@netfilter.org
Cc: gorcunov@gmail.com, randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49CF62A2.6050803@netfilter.org>
References: <20090329064704.GA7255@localhost>
	<20090328.234739.26481917.davem@davemloft.net>
	<49CF62A2.6050803@netfilter.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 29 Mar 2009 13:59:30 +0200

> David Miller wrote:
> > From: Cyrill Gorcunov <gorcunov@gmail.com>
> > Date: Sun, 29 Mar 2009 10:47:04 +0400
> > 
> >> [Randy Dunlap - Sat, Mar 28, 2009 at 09:26:42PM -0700]
> >> ... 
> >> | works_for_me.  Thanks.
> >> | but missing S-O-B.
> >> | 
> >> | Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> >> ...
> >>
> >> Thanks for testing Randy. So if nobody will complain
> >> here is a solid version of the patch. Though I would like
> >> if Pablo or Patrick confirm its correctness. Thanks!
> > 
> > I'll apply this once Patrick or Pablo have a look at it.
> 
> I think that the patch attached is better since it removes the overhead
> of the IPv6 dependency, which is indeed too much for the use of one
> function. Thanks.

I think it's a lot better too, applied, thanks!
