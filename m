Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYHZWjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYHZWjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYHZWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:39:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYHZWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:39:29 -0400
Date: Tue, 26 Aug 2008 18:39:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080826223917.GA2234@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826223402.GB27724@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:34:03AM +0400, Alexey Dobriyan wrote:
> One the bad side, where are those nice tracing modules? Where are they?

Yes.  Merging such a huge amount of code that doesn't actually give
the kernel any new capabilities seems like a strange idea.  What users
of this infrastrucure can we see that it can be merged with in one go?

