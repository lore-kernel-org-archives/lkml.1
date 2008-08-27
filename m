Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYH0OHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYH0OHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbYH0NzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:55:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbYH0NzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:55:05 -0400
Date: Wed, 27 Aug 2008 09:54:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080827135453.GA31240@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m7ia3xqev.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 08:17:12PM -0400, Frank Ch. Eigler wrote:
> Among others, utrace is an enablement layer for systemtap user-space
> probing, through another subsequent part that implements a
> kprobes-like API for user-space tasks.  All this code now exists in at
> least prototype form, so if you need to see the bigger picture, look
> that way.  Other users are anticipated, but first we need to get past
> the chicken-and-egg.

As usual nothing of that stuff has any real in-kernel users so the same
argument applies here.  If it did have real uses it could be merged at
the same time.  But the current uprobes mess is not a reason to merge
utrace.

