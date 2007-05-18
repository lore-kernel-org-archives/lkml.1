Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXERKO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXERKO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXERKOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:14:20 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1282 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754633AbXERKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:14:20 -0400
Date: Fri, 18 May 2007 20:13:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 5/15] Make crypto API use seq_list_xxx helpers
Message-ID: <20070518101328.GA19271@gondor.apana.org.au>
References: <464D6E87.7060605@sw.ru> <464D731F.1010101@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464D731F.1010101@sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 01:34:23PM +0400, Pavel Emelianov wrote:
> Simple and stupid - just use the same code from another
> place in the kernel.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>

Ack.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
