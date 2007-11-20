Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbXKTHlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbXKTHlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXKTHli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:41:38 -0500
Received: from koto.vergenet.net ([210.128.90.7]:44775 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbXKTHlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:41:37 -0500
Date: Tue, 20 Nov 2007 16:41:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jes Sorensen <jes@sgi.com>,
       Tony Luck <tony.luck@intel.com>, linux-altix@sgi.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 01/59] arch/ia64: Add missing "space"
Message-ID: <20071120074132.GA3402@verge.net.au>
References: <1195523331-15303-1-git-send-email-joe@perches.com> <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <20071120065431.GC10490@verge.net.au> <1195542565.4675.104.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195542565.4675.104.camel@localhost>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:09:25PM -0800, Joe Perches wrote:
> On Tue, 2007-11-20 at 15:54 +0900, Simon Horman wrote:
> > Is it really neccessary for this fragment to create a line that
> > is greater than 80 characters long? Persumably the entire reason
> > that the printk line was split in the first place was to avoid
> > a long line.
> 
> No.  Many other lines in that source file are > 80 char.

That may be so, but surely adding another one makes
things slightly worse.

> My initial preference was to reformat the indented lines to the
> printk open parenthesis, but the minimal change seemed better.
> 
> cheers, Joe

-- 
Horms

