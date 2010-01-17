Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768Ab0AQKy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab0AQKy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 05:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611Ab0AQKyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 05:54:25 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33262 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953Ab0AQKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 05:54:24 -0500
Date: Sun, 17 Jan 2010 21:54:19 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: Re: [PATCH] crypto: make Open Firmware device id constant
Message-ID: <20100117105419.GB32270@gondor.apana.org.au>
References: <4B4C2C69.9000804@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B4C2C69.9000804@freemail.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:01:45AM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The match_table field of the struct of_device_id is constant in <linux/of_platform.h>
> so it is worth to make the initialization data also constant.

Applied to cryptodev.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
