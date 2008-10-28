Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYJ1TPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYJ1TPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYJ1TPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:15:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYJ1TPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:15:33 -0400
Date: Tue, 28 Oct 2008 15:15:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] cleanup paccept
Message-ID: <20081028191531.GA1007@infradead.org>
References: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 03:09:51PM -0400, Ulrich Drepper wrote:
> This patch doesn't change *any* functionality from what is currently
> in the upstream kernel.  There is no reason to start arguing again and
> for me to explain everything the way I did it months ago.  This is just
> a *cleanup patch*, nothing else.  If you want to know why this cleanup
> is needed read the discussions of

Umm, it does enabled functionality that wasn't enabled before.  And that
functionality includes a syscall.  So any chance you could write a
proper changelog that describes what you actually do instead of lots of
ranting and references to old posts?

And no "[PATCH] cleanup paccept" isn't really a good subject for adding
a new syscalls either.

