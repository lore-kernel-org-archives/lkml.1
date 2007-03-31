Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXCaCrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXCaCrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbXCaCrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:47:33 -0400
Received: from koto.vergenet.net ([210.128.90.7]:37049 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410AbXCaCrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:47:33 -0400
Date: Sat, 31 Mar 2007 11:37:23 +0900
From: Simon Horman <horms@verge.net.au>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, simon.derr@bull.net
Subject: Re: [PATCH] CPUSETS: add mems to basic usage documentation
Message-ID: <20070331023723.GB29836@verge.net.au>
References: <20070330041001.GA20566@verge.net.au> <20070330023047.216048a6.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330023047.216048a6.pj@sgi.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 02:30:47AM -0700, Paul Jackson wrote:
> Simon Horman wrote:
> > +++ linux-2.6/Documentation/cpusets.txt	2007-03-30 13:03:19.000000000 +0900
> > ...
> > +Add some mems:
> > +# /bin/echo 0-7 > mems
> 
> Nice change - thanks.
> 
> Acked-by: Paul Jackson <pj@sgi.com>

Thanks

> (I probably would not add a dmesg complaint; we don't usually
> do that for ordinary system call failures.  Pay close attention
> to the resulting errno - in this case ENOSPC.)

Understood

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

