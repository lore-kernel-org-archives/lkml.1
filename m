Return-Path: <linux-kernel-owner+w=401wt.eu-S937340AbYEUULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937340AbYEUULd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937277AbYEUUKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:10:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54825
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933322AbYEUUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:10:51 -0400
Date: Wed, 21 May 2008 13:10:46 -0700 (PDT)
Message-Id: <20080521.131046.242739198.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: gorcunov@gmail.com, tytso@mit.edu, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: CFD: linux-wanking@vger.kernel.org
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080521123127.3b3b66af.akpm@linux-foundation.org>
References: <20080521104644.5b6f4e63.akpm@linux-foundation.org>
	<20080521185725.GD6932@cvg>
	<20080521123127.3b3b66af.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 21 May 2008 12:31:27 -0700

> The #1 project for all kernel beginners should surely be "make sure
> that the kernel runs perfectly at all times on all machines which you
> can lay your hands on".  Usually the way to do this is to work with
> others on getting things fixed up (this can require persistence!) but
> that's fine - it's a part of kernel development.

Indeed.  A lot of the time I see new people, or people making
suggestions to them, so fixated on wanting to implement new features.

To me that is absolutely the wrong way to go about this.

It's so much more useful, for both the community and the individual,
to fix bugs.  Fixing a bug forces you to learn how the kernel works at
least on some level, and fixing a bug always makes Linux better.

Implementing a new feature does not necessarily have either of those
two important qualities, so it is never the place for new people to
start.

Fixing bugs will give someone a real identity and place in the
community.

You want real Linux kernel "street cred"?  Fix a lot of bugs, then you
can implement a thousand new features and people will take you
seriously because you've shown that you can and will fix things.
