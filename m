Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZAILZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZAILZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 06:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZAILZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 06:25:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60810 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZAILZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 06:25:33 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Hellwig <hch@infradead.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090108175338.2abbee16.akpm@linux-foundation.org>
References: <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org>
Message-Id: <20090109202010.2909.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  9 Jan 2009 20:25:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I discussed this with Phillip a bit, and it looks like we'll go for a
> 2.6.21 merge.  This gives a couple of months for testing and review in
> linux-next.
> 
> Of course, this assumes that someone will actually perform that testing
> and review.  Chances are that it'll just sit there, getting nothing more
> than compilation testing.

As far as I heared from japanese embedded developer, squashfs is already used by
embedded community and some consumer electronics product.
Therefore, I think it can merge now if it's no impact to other subsystem.


> Apparently I reviewed the code a while back - that grey cell must have
> died.  Does anyone else intend to review the code in that timeframe? 
> If not, we might as well merge it now, if ever..


