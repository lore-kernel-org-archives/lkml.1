Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbZAMHow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbZAMHow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 02:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZAMHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 02:44:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43296
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbZAMHok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:44:40 -0500
Date: Mon, 12 Jan 2009 23:44:41 -0800 (PST)
Message-Id: <20090112.234441.131571840.davem@davemloft.net>
To: joe.tian.kernel@gmail.com
Cc: lizf@cn.fujitsu.com, qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: fix wrong English expression in comments
From: David Miller <davem@davemloft.net>
In-Reply-To: <6b1ba94c0901122336r511fa316o5f520a8d2d9d6e0@mail.gmail.com>
References: <496a3c51.09876e0a.03fe.7e80@mx.google.com>
	<496A9753.80802@cn.fujitsu.com>
	<6b1ba94c0901122336r511fa316o5f520a8d2d9d6e0@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: joe tian <joe.tian.kernel@gmail.com>
Date: Tue, 13 Jan 2009 15:36:51 +0800

> 2009/1/12 Li Zefan <lizf@cn.fujitsu.com>:
> >> @@ -103,7 +103,7 @@ struct inet_bind_bucket;
> >>  struct inet_timewait_sock {
> >>       /*
> >>        * Now struct sock also uses sock_common, so please just
> >> -      * don't add nothing before this first member (__tw_common) --acme
> >> +      * don't add anything before this first member (__tw_common) --acme
> >
> > They are the same meaning...
> >
> I don't think they are the same meaning.
> I think "don't add anything" means "do add nothing" but not means "don't add
> nothing"

No offense to anyone, but the only people arguing for "correctness"
seem to be non-native speakers of English.  Is this correct? :-)

As Ben tries to explain, "don't add nothing" is a colloquialism of
English that in fact can mean "do not add"

It sounds amusing when read, and I'm not killing the character and
personality of this comment just for some language lawyering.

No way.
