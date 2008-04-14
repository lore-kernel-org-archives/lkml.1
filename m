Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbYDNJHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbYDNJHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbYDNJHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:07:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYDNJHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:07:18 -0400
Date: Mon, 14 Apr 2008 05:06:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, w@1wt.eu,
       david@lang.hm, sclark46@earthlink.net, johnpol@2ka.mipt.ru, rjw@sisk.pl,
       tilman@imap.cc, Valdis.Kletnieks@vt.edu, lkml@rtr.ca,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, git@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
Message-ID: <20080414090634.GB15541@infradead.org>
References: <20080413232441.e216a02c.akpm@linux-foundation.org> <20080414072328.GW9785@ZenIV.linux.org.uk> <20080414010412.c42dc560.akpm@linux-foundation.org> <20080414.013058.149905948.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414.013058.149905948.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 01:30:58AM -0700, David Miller wrote:
> We can ask more subsystem tree maintainers to run their trees more
> strictly, review patches more closely, etc.  But, be honest, good luck
> getting that from the guys who do subsystem maintainence in their
> spare time on the weekends.  The remaining cases should know better,
> or simply don't care.

Actually my impression is that spare-time maitainer produce much better
code and subsystem trees than corporate-drones.  But of course there's
a lot of shades between those two extremes.
