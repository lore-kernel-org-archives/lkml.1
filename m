Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZBQR12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZBQR12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZBQR1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:27:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53334 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbZBQR1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:27:18 -0500
Subject: Re: [PATCH -v1 03/11] fsnotify: add in inode fsnotify markings
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org, malware-list@lists.printk.net
In-Reply-To: <20090212135726.bbab736e.akpm@linux-foundation.org>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
	 <20090209211537.8985.73991.stgit@paris.rdu.redhat.com>
	 <20090212135726.bbab736e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 12:26:30 -0500
Message-Id: <1234891590.19964.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 13:57 -0800, Andrew Morton wrote:
> <picks a patch at random>
> 
> I don't have a good sense of what value all of this work brings to
> Linux.  Why should I get excited about this?  Why is it all worth the
> time/effort/risk/etc which would be involved in getting it integrated?
> 
> All rather unclear, but very important!

I have largely taken your comments and rewritten this patch (and a
couple others) to be easier to understand and review.

current patches are at http://people.redhat.com/~eparis/fsnotify

I received some offline comments which I intend to address and will be
reposting later this week.

thank you!

