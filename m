Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYDRKhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYDRKhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYDRKhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:37:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYDRKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:37:33 -0400
Date: Fri, 18 Apr 2008 06:37:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
Message-ID: <20080418103731.GA29204@infradead.org>
References: <200804170949.36864.denys@visp.net.lb> <4807EDD6.8000705@sandeen.net> <20080418074041.GA9839@infradead.org> <200804181332.31177.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804181332.31177.denys@visp.net.lb>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 01:32:30PM +0300, Denys Fedoryshchenko wrote:
> AUFS(same as COSS, UFS, NULL) is way of handling with cache storage in squid, and nothing else. It is userspace and not involved deeply with kernel things.
> Since long long time i didn't had any single problem with it.
> Kernel is fully vanilla.

Ah, okay.  There's also a kernel filesystem driver doing unioning that's
also called aufs that I'm referring to.  sorry for the noise.

