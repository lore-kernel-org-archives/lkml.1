Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYDRHkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYDRHkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYDRHks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:40:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYDRHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:40:48 -0400
Date: Fri, 18 Apr 2008 03:40:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
Message-ID: <20080418074041.GA9839@infradead.org>
References: <200804170949.36864.denys@visp.net.lb> <4807EDD6.8000705@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4807EDD6.8000705@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 07:39:50PM -0500, Eric Sandeen wrote:
> Denys Fedoryshchenko wrote:
> > Hi again
> > 
> > I reported about http://bugzilla.kernel.org/show_bug.cgi?id=10421 , and it is triggerable on different loaded servers with XFS (squid with aufs),
> 
> Oh, aufs was not listed in the bug report.  that's an out of tree
> module, right?  Is it completely up to date and safe with 2.6.25?

And it's a completely crappy one.  I personally would through away every
bug report with that piece of junk involved.

