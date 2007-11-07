Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbXKGJNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbXKGJNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXKGJNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:13:10 -0500
Received: from koto.vergenet.net ([210.128.90.7]:50840 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXKGJNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:13:08 -0500
Date: Wed, 7 Nov 2007 18:13:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Luming <luming.yu@intel.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] ia64: remove per_cpu_offset()
Message-ID: <20071107091302.GA3795@verge.net.au>
References: <20071107064627.GD3571@verge.net.au> <3877989d0711062255r45bdd437ic115fc52d064c59b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0711062255r45bdd437ic115fc52d064c59b@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:55:24PM +0800, Luming Yu wrote:
> NAK for now.
> 
> I'm trying to add lockdep , so please don't delete it until it could
> be proved really useless...
> Please don't hurry...

Ok, in that case I Re-ack your typo fix patch.
Sorry for the noise.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

