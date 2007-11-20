Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXKTHJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXKTHJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXKTHJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:09:29 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2552 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXKTHJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:09:28 -0500
Subject: Re: [PATCH 01/59] arch/ia64: Add missing "space"
From: Joe Perches <joe@perches.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, Jes Sorensen <jes@sgi.com>,
       Tony Luck <tony.luck@intel.com>, linux-altix@sgi.com,
       linux-ia64@vger.kernel.org
In-Reply-To: <20071120065431.GC10490@verge.net.au>
References: <1195523331-15303-1-git-send-email-joe@perches.com>
	 <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
	 <20071120065431.GC10490@verge.net.au>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 23:09:25 -0800
Message-Id: <1195542565.4675.104.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 15:54 +0900, Simon Horman wrote:
> Is it really neccessary for this fragment to create a line that
> is greater than 80 characters long? Persumably the entire reason
> that the printk line was split in the first place was to avoid
> a long line.

No.  Many other lines in that source file are > 80 char.

My initial preference was to reformat the indented lines to the
printk open parenthesis, but the minimal change seemed better.

cheers, Joe

