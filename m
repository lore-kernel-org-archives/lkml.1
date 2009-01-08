Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbZAHQuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbZAHQuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZAHQuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:50:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbZAHQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:50:31 -0500
Date: Thu, 8 Jan 2009 11:50:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090108165029.GA10951@infradead.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
> Please consider pulling my linux-next branch
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
> 
> The patches have been posted to LKML and linux-fsdevel over the last
> couple of months and have been reviewed and changed as requested.
> Diffstat below.
> 
> Squashfs is a compressed read-only filesystem. It compresses metadata
> and data, and uses up to 1 MiB block sizes for greater compression.

That seems pretty fast for something only posted this week and not
even in -next.

