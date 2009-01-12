Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZALBe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZALBe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZALBeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:34:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:4120 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbZALBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:34:13 -0500
From: Ben Hutchings <bhutchings@solarflare.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Qinghuang Feng <qhfeng.kernel@gmail.com>, davem@davemloft.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <496A9753.80802@cn.fujitsu.com>
References: <496a3c51.09876e0a.03fe.7e80@mx.google.com>
	 <496A9753.80802@cn.fujitsu.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 12 Jan 2009 01:39:18 +0000
Message-Id: <1231724358.2674.13.camel@hashbaz.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.4.253
X-SA-Exim-Mail-From: bhutchings@solarflare.com
Subject: Re: [PATCH] NET: fix wrong English expression in comments
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 09:05 +0800, Li Zefan wrote:
> > @@ -103,7 +103,7 @@ struct inet_bind_bucket;
> >  struct inet_timewait_sock {
> >  	/*
> >  	 * Now struct sock also uses sock_common, so please just
> > -	 * don't add nothing before this first member (__tw_common) --acme
> > +	 * don't add anything before this first member (__tw_common) --acme
> 
> They are the same meaning...

A double-negative can be an informal way of reinforcing a negative, but
can sometimes mean the positive.  So this change would remove a minor
ambiguity.  However I think it should be clear that it is not compulsory
to add new members to the structure. ;-)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


