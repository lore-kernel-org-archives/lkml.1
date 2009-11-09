Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZKISxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZKISxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZKISxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:53:22 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45802 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbZKISxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:53:21 -0500
Date: Mon, 9 Nov 2009 13:52:59 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new
	instructions via gas macro
Message-ID: <20091109185259.GA9588@gondor.apana.org.au>
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com> <20091105142336.GB1910@gondor.apana.org.au> <4AF30447.2030705@zytor.com> <20091108105619.GF11372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108105619.GF11372@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 11:56:19AM +0100, Ingo Molnar wrote:
>
> > I'm not Ingo, but:
> > 
> > Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> Fine to me too and for future variations thereof.

Thanks guys I'll put this into cryptodev now.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
