Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbXIJOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbXIJOHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbXIJOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:07:41 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4663 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbXIJOHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:07:40 -0400
Date: Mon, 10 Sep 2007 10:05:07 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, vladislav.yasevich@hp.com,
       sri@us.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net
Subject: Re: [Lksctp-developers] [-mm patch] net/sctp/socket.c: make 3 variables static
Message-ID: <20070910140507.GD14606@hmsendeavour.rdu.redhat.com>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202554.GY3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909202554.GY3563@stusta.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:25:54PM +0200, Adrian Bunk wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> >  git-net.patch
> >...
> >  git trees
> >...
> 
> This patch makes the following needlessly globalvariables static:
> - sctp_memory_pressure
> - sctp_memory_allocated
> - sctp_sockets_allocated
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Looks fine to me
Acked-by: Neil Horman <nhorman@tuxdriver.com>

Neil

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
