Return-Path: <linux-kernel-owner+w=401wt.eu-S1762418AbXIVKPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762418AbXIVKPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 06:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXIVKPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 06:15:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:9590 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXIVKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 06:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i1x9BkEzmq+FB6aIaiZq3N1KhE2ZKQvA4KnIame7XIqSf6v2pIt7Zf66neUCt5Ou+AEnNTp7T6DjqnMEtiSkPd19TVkv6kyPuC7b8bqLUbYlSlFckL6prrQcaYeOMS5IUdffs9uL2ZkJ6zpvgCLjsyxkiWjzycMrBOLxtSvFi0c=
Date: Sat, 22 Sep 2007 14:15:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: memset as memzero
Message-ID: <20070922101536.GC7226@cvg>
References: <20070922083355.GA7226@cvg> <Pine.LNX.4.64.0709220441090.21302@localhost.localdomain> <20070922093507.GB7226@cvg> <Pine.LNX.4.64.0709220553400.25743@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709220553400.25743@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Robert P. J. Day - Sat, Sep 22, 2007 at 05:55:04AM -0400]
| On Sat, 22 Sep 2007, Cyrill Gorcunov wrote:
| 
| > Thanks Robert for the answer, I'll mark this (clear_page) in my
| > "must to take a look" list ;)
| 
| there's already been a discussion about clear_page() as well:
| 
|   http://lists.openwall.net/linux-kernel/2006/12/29/39
| 
| you might want to start there to get up to speed if you intend to
| invest any time in this.
| 
| rday
| -- 
| ========================================================================
| Robert P. J. Day
| Linux Consulting, Training and Annoying Kernel Pedantry
| Waterloo, Ontario, CANADA
| 
| http://crashcourse.ca
| ========================================================================
| 

thanks

		Cyrill

