Return-Path: <linux-kernel-owner+w=401wt.eu-S1750730AbYK1MuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750730AbYK1MuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYK1Mt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:49:57 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48972 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752991AbYK1Mt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:49:57 -0500
Date: Fri, 28 Nov 2008 20:49:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-mm 4/8] crypto: remove uses of __constant_{endian}
	helpers
Message-ID: <20081128124946.GA31658@gondor.apana.org.au>
References: <1227733971.5511.126.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227733971.5511.126.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 01:12:51PM -0800, Harvey Harrison wrote:
> Base versions handle constant folding just fine.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Patch applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
