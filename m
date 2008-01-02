Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYABIK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYABIK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 03:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYABIKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 03:10:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYABIKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 03:10:18 -0500
Date: Wed, 2 Jan 2008 08:10:05 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, bunk@kernel.org, vapier@gentoo.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] linux/ufs_fs.h: use __u64 for userspace
Message-ID: <20080102081005.GA17174@infradead.org>
References: <200801012051.41474.vapier@gentoo.org> <20080102020242.GP27566@does.not.exist> <20080102075033.GA16267@infradead.org> <20080102.000444.18510965.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102.000444.18510965.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 12:04:44AM -0800, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Wed, 2 Jan 2008 07:50:33 +0000
> 
> > The only non-kernel user of this known to me is silo, which should just
> > have it's own header documenting the solaris sparc ufs variant it needs
> > to understand, possibly by using a copy of the kernel version at any
> > given point of time.
> 
> And this is what the current SILO sources do.

Nice.
