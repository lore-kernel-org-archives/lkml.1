Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXKSWYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXKSWYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXKSWYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:24:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56048 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXKSWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:24:14 -0500
Date: Mon, 19 Nov 2007 22:24:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.24-rc3-git1: Reported regressions from 2.6.23
Message-ID: <20071119222406.GA15242@infradead.org>
References: <200711192315.05767.rjw@sisk.pl> <20071119222110.GD22293@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119222110.GD22293@fieldses.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:21:10PM -0500, J. Bruce Fields wrote:
> On Mon, Nov 19, 2007 at 11:15:05PM +0100, Rafael J. Wysocki wrote:
> > Subject		: nfsd gets stuck when underlying filesystem is XFS
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > 		  Chris Wedgwood <cw@f00f.org>
> > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9400
> > Handled-By	: "J. Bruce Fields" <bfields@fieldses.org>
> > Patch		: 
> 
> I'm assuming Christoph is handling this:

Yes, I'm working on this.   There should be a patch by tomorrow.
