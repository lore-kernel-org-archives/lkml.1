Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZE0VDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZE0VDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZE0VDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:03:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37860 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbZE0VDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:03:11 -0400
Date: Wed, 27 May 2009 14:03:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Paul McKenney to RCU and RCUTORTURE
Message-ID: <20090527210312.GG6729@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1243131992.git.joe@perches.com> <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com> <20090526234241.GD7006@linux.vnet.ibm.com> <1243448316.27337.28.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243448316.27337.28.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 11:18:36AM -0700, Joe Perches wrote:
> On Tue, 2009-05-26 at 16:42 -0700, Paul E. McKenney wrote:
> > Hmmm...  Given that you are removing LKML from RCU and rcutorture,
> > could you please add me?  If someone misses "THE REST", I very likely
> > won't see their bug/issue/question.
> > 
> > P:	Paul E. McKenney
> > M:	paulmck@linux.vnet.ibm.com

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ab45488..0426b39 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4630,6 +4630,8 @@ F:	drivers/net/wireless/ray*
>  RCUTORTURE MODULE
>  P:	Josh Triplett
>  M:	josh@freedesktop.org
> +P:	Paul E. McKenney
> +M:	paulmck@linux.vnet.ibm.com
>  S:	Maintained
>  F:	Documentation/RCU/torture.txt
>  F:	kernel/rcutorture.c
> @@ -4656,6 +4658,8 @@ F:	net/rds/
>  READ-COPY UPDATE (RCU)
>  P:	Dipankar Sarma
>  M:	dipankar@in.ibm.com
> +P:	Paul E. McKenney
> +M:	paulmck@linux.vnet.ibm.com
>  W:	http://www.rdrop.com/users/paulmck/rclock/
>  S:	Supported
>  F:	Documentation/RCU/rcu.txt
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
