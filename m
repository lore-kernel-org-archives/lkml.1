Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYGOEhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYGOEhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYGOEhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:37:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYGOEhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:37:22 -0400
Date: Tue, 15 Jul 2008 00:37:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bugfixes
Message-ID: <20080715043718.GA30017@infradead.org>
References: <E1KIbeO-0001yQ-N4@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KIbeO-0001yQ-N4@closure.thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 11:56:28PM -0400, Theodore Ts'o wrote:
> Alex Tomas (2):
>       vfs: add hooks for ext4's delayed allocation support

This is still missing kerneldoc comments for the newly exported
functions.

>       ext4: Add delayed allocation support in data=writeback mode

And for this one I haven't even heard back on my review comments.  None
of them is a merge blocker so it's not critical, but I find it quite odd
that the pull request is coming before even replying to the review
comments.

