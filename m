Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYJZIjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYJZIjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 04:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYJZIjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 04:39:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYJZIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 04:39:40 -0400
Date: Sun, 26 Oct 2008 04:39:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081026083939.GA19394@infradead.org>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081026081717.GB20872@infradead.org> <20081026193421.f5f7d8f1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026193421.f5f7d8f1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 07:34:21PM +1100, Stephen Rothwell wrote:
> Presumably what was merged was slightly different (or the commits were
> split up differently).  This is the same problem I have with the kvm tree.

It should be the same, but the xfs trees have been a bit of a maze
recently, so it shouldn't be a surprise that your list got out of sync.

