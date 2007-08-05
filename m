Return-Path: <linux-kernel-owner+w=401wt.eu-S1761571AbXHEJMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761571AbXHEJMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXHEJMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:12:38 -0400
Received: from 1wt.eu ([62.212.114.60]:1149 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXHEJMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:12:37 -0400
Date: Sun, 5 Aug 2007 11:11:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: m.c.p@kernel.linux-systeme.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: what's about 2.2 kernel?
Message-ID: <20070805091131.GD6002@1wt.eu>
References: <46B58D50.8090301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B58D50.8090301@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 10:41:52AM +0200, Xose Vazquez Perez wrote:
> hi,
> 
> time to release a final 2.2.27 and close the
> 2.2 tree ???
> 
> 
> The latest 2.2 version  : 2.2.26     2004-02-25 00:28 UTC
> The latest prepatch 2.2 : 2.2.27-rc2 2005-01-12 23:55 UTC

No, I think it would dupe users into thinking that 2.2.27 is up to date,
while it would have missed a lot of security fixes. At least in the
current situation, people tend not to trust it. It's rather sad that it
ended that way, I've been happily putting it everywhere for a long time
when I was telling everyone that 2.4 was an unreliable crap. I hope I
will never set the same fate to 2.4 :-/

If you're looking for updates for 2.2, you should take a look at OWL
and PAX patches, both of those tend to include many security fixes,
maybe they're still up to date, but I would doubt about that now.

> -- 
> Politicos de mierda, yo no soy un terrorista.

BTW, it would be kind if you could avoid gratuitous bad words in your sig.
While LKML has a language of its own, it serves no useful purpose to raise
the bar that way.

Thanks,
Willy

