Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZBSSyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZBSSyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZBSSyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:54:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZBSSyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:54:38 -0500
Date: Thu, 19 Feb 2009 13:54:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090219185434.GB24117@infradead.org>
References: <20090218144105.GZ30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218144105.GZ30821@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 03:41:06PM +0100, Jens Axboe wrote:
> Hi Linus,
> 
> One trivial patch, otherwise it's all bug fixes or regressions. Please
> pull.

Any chance you could look into the barrier fail warning spew regression
introduced early in the 2.6.29 circle?

