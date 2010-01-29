Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759Ab0A2Lf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0A2Lf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728Ab0A2Lfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:35:55 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:40190 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756651Ab0A2Lfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:35:54 -0500
Date: Fri, 29 Jan 2010 22:35:44 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jeff Angielski <jeff@theptrgroup.com>, Matt Mackall <mpm@selenic.com>,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
Message-ID: <20100129113544.GC1309@gondor.apana.org.au>
References: <4B591573.60602@theptrgroup.com> <1264480808.2401.78.camel@localhost.localdomain> <1264484928.3536.1017.camel@calx> <1264500214.3867.21.camel@localhost> <4B5F9A78.7080000@theptrgroup.com> <1264558433.3536.1543.camel@calx> <4B5FADE8.30803@theptrgroup.com> <1264566010.2401.143.camel@localhost.localdomain> <20100129112757.GA1309@gondor.apana.org.au> <1264764729.4371.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264764729.4371.12.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 01:32:09PM +0200, Artem Bityutskiy wrote:
> 
> I've just cloned:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
> 
> and do not see it there.

Should show up soon once my push makes it through.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
