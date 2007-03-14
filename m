Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbXCNAlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbXCNAlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXCNAlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:41:07 -0400
Received: from holomorphy.com ([66.93.40.71]:38802 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXCNAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:41:06 -0400
Date: Tue, 13 Mar 2007 17:41:08 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.com, holt@sgi.com,
       linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
Message-ID: <20070314004108.GL2986@holomorphy.com>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com> <20070312.155157.74747634.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312.155157.74747634.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:51:57PM -0700, David Miller wrote:
> Someone with some extreme patience could do the sparc 32-bit port too,
> in fact it's lacking the cached PGD update logic that x86 et al. have
> so it would even end up being a bug fix :-)  This lack is why sparc32
> pre-initializes the vmalloc/module area PGDs with static page tables
> at boot time, FWIW.

I'll spare everyone the details and let code if/when it appears stand
in for promises on the sparc32 front.


-- wli
