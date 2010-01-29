Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675Ab0A2L2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0A2L2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399Ab0A2L2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:28:11 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53440 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754396Ab0A2L2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:28:10 -0500
Date: Fri, 29 Jan 2010 22:27:57 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jeff Angielski <jeff@theptrgroup.com>, Matt Mackall <mpm@selenic.com>,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
Message-ID: <20100129112757.GA1309@gondor.apana.org.au>
References: <4B591573.60602@theptrgroup.com> <1264480808.2401.78.camel@localhost.localdomain> <1264484928.3536.1017.camel@calx> <1264500214.3867.21.camel@localhost> <4B5F9A78.7080000@theptrgroup.com> <1264558433.3536.1543.camel@calx> <4B5FADE8.30803@theptrgroup.com> <1264566010.2401.143.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264566010.2401.143.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 06:20:10AM +0200, Artem Bityutskiy wrote:
>
> Thanks for testing. So, who would bring Matt's patch upstream then, hmm?

I've got it in crypto-2.6.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
