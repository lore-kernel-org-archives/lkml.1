Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZCCDDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZCCDDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZCCDC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:02:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44505 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbZCCDC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:02:58 -0500
Date: Tue, 3 Mar 2009 11:02:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>, karl@hiramoto.org,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] crypto: fix handling of sg buffers in ixp4xx driver
Message-ID: <20090303030249.GB26480@gondor.apana.org.au>
References: <20090226232025.GE5811@n2100.arm.linux.org.uk> <20090227005033.GA20046@gondor.apana.org.au> <20090302114511.GE6283@elara.bln.innominate.local> <20090302204239.GC25699@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302204239.GC25699@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 08:42:39PM +0000, Russell King - ARM Linux wrote:
>
> So, sorry, I'm not qualified to review this.  Please find someone else
> who knows about crypto stuff.

No worries, I'm onto it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
