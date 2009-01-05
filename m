Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZAEJRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZAEJRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZAEJRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:17:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbZAEJRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:17:33 -0500
Date: Mon, 05 Jan 2009 01:17:33 -0800 (PST)
Message-Id: <20090105.011733.225349838.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090105011202.835e75ec.akpm@linux-foundation.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090105090239.GB17530@uranus.ravnborg.org>
	<20090105011202.835e75ec.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 5 Jan 2009 01:12:02 -0800

> On Mon, 5 Jan 2009 10:02:39 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Hi Andrew.
> > 
> > > sparc64-use-unsigned-long-long-for-u64.patch
> > > sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
> > 
> > Please drop these two.
> 
> Might, if they break my build.

They don't build, I tested them when I tried integrated Sam's
patches.

Please toss these, Sam and I will make sure it gets added once we sort
out the build failures.

> I tend to hang onto things I like, even if they aren't right yet.
> 
> We really really need to push ahead with fixing this stuff.

If we are working on making the patches actually work, and they are
known to break the build, you should just toss let us take care of it.

At least in cases like this one. :-)
