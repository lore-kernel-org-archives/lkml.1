Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbZAMFxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbZAMFxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZAMFxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:53:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42920
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZAMFxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:53:19 -0500
Date: Mon, 12 Jan 2009 21:53:20 -0800 (PST)
Message-Id: <20090112.215320.197154233.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: lizf@cn.fujitsu.com, qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: fix wrong English expression in comments
From: David Miller <davem@davemloft.net>
In-Reply-To: <1231724358.2674.13.camel@hashbaz.i.decadent.org.uk>
References: <496a3c51.09876e0a.03fe.7e80@mx.google.com>
	<496A9753.80802@cn.fujitsu.com>
	<1231724358.2674.13.camel@hashbaz.i.decadent.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Mon, 12 Jan 2009 01:39:18 +0000

> On Mon, 2009-01-12 at 09:05 +0800, Li Zefan wrote:
> > > @@ -103,7 +103,7 @@ struct inet_bind_bucket;
> > >  struct inet_timewait_sock {
> > >  	/*
> > >  	 * Now struct sock also uses sock_common, so please just
> > > -	 * don't add nothing before this first member (__tw_common) --acme
> > > +	 * don't add anything before this first member (__tw_common) --acme
> > 
> > They are the same meaning...
> 
> A double-negative can be an informal way of reinforcing a negative, but
> can sometimes mean the positive.  So this change would remove a minor
> ambiguity.  However I think it should be clear that it is not compulsory
> to add new members to the structure. ;-)

After all of this discussion, I think I'm going to keep this comment
as-is. :-)

