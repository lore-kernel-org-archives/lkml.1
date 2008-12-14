Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYLNWrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYLNWrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYLNWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:47:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYLNWrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:47:40 -0500
Subject: Re: [RFC PATCH -v4 14/14] shit on top for debugging
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, Christoph Hellwig <hch@infradead.org>,
       zbr@ioremap.net, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LRH.1.10.0812150938120.7708@tundra.namei.org>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215228.27112.72672.stgit@paris.rdu.redhat.com>
	 <alpine.LRH.1.10.0812150938120.7708@tundra.namei.org>
Content-Type: text/plain
Date: Sun, 14 Dec 2008 17:47:07 -0500
Message-Id: <1229294827.1927.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 09:40 +1100, James Morris wrote:
> On Fri, 12 Dec 2008, Eric Paris wrote:
> 
> > 
> 
> Given that this code will probably need some general debugging, perhaps 
> use pr_debug.

an accidental patch left on top of my stack which I didn't mean to send.
But sure, that's a great idea.  I'll fix the comments and do it that
way....

-Eroc

