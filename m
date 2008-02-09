Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYBIG6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYBIG6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYBIG6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:58:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYBIG6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:58:22 -0500
Date: Sat, 9 Feb 2008 01:58:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] kgdb core and rs232 I/O drivers
Message-ID: <20080209065816.GA13062@infradead.org>
References: <47AD4AAD.6010500@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AD4AAD.6010500@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 12:39:41AM -0600, Jason Wessel wrote:
> The kgdb tree has been collapsed review.  It includes
> the kgdb core, the x86 arch, the kgdb8250 uart driver
> and the kgdb console sharing driver.
> 
> Since the last time the kgdb patches were posted to LKML
> several months ago, the kgdb core has undergone some
> significant cleanup, as well as the kgdb I/O driver
> interface.
> 
> All the kgdb hooks are initialized dynamically only when a
> kgdb I/O module is configured. When not configured
> kgdb will not exist in any kernel execution path.
> 
> Further comments are certainly welcome.

Any chance you could post actual patches for reviewing it?

