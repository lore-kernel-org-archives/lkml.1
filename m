Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZCPMDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZCPMDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbZCPMD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:03:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZCPMD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:03:29 -0400
Date: Mon, 16 Mar 2009 08:02:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       minchan.kim@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Point the UNEVICTABLE_LRU config option at the
	documentation
Message-ID: <20090316120224.GA16506@infradead.org>
References: <20090316105945.18131.82359.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316105945.18131.82359.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:59:45AM +0000, David Howells wrote:
> Point the UNEVICTABLE_LRU config option at the documentation describing the
> option.

Didn't we decide a while ago that the option is pointless and the code
should always be enabled?

