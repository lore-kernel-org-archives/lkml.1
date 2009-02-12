Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbZBLXKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbZBLXKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761186AbZBLXKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:10:20 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46564 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760904AbZBLXKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:10:18 -0500
Date: Fri, 13 Feb 2009 07:09:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] Export symbol ksize()
Message-ID: <20090212230957.GB21609@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com> <20090210134651.GA5115@epbyminw8406h.minsk.epam.com> <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI> <20090212104349.GA13859@gondor.apana.org.au> <1234435521.28812.165.camel@penberg-laptop> <20090212105034.GC13859@gondor.apana.org.au> <1234454104.28812.175.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234454104.28812.175.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 05:55:04PM +0200, Pekka Enberg wrote:
> 
> OK, fair enough, I applied Kirill's patch. Thanks.

Thanks Pekka!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
