Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZKWMUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZKWMUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZKWMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:20:08 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:35224 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756997AbZKWMUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:20:07 -0500
Date: Mon, 23 Nov 2009 20:20:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Huang Ying <ying.huang@intel.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: ghash - put proper .data section in place
Message-ID: <20091123122006.GD6424@gondor.apana.org.au>
References: <alpine.LSU.2.00.0911181713200.15039@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911181713200.15039@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:15:44PM +0100, Jiri Kosina wrote:
> Lbswap_mask, Lpoly and Ltwo_one should clearly belong to
> .data section, not .text.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Patch applied.  Thanks Jiri.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
