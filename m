Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYFBFpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYFBFpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYFBFp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:45:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36717 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751576AbYFBFp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:45:28 -0400
Date: Mon, 2 Jun 2008 15:45:17 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcrypt: init test SG tables
Message-ID: <20080602054517.GA20321@gondor.apana.org.au>
References: <20080531005844.GA6751@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531005844.GA6751@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 04:58:44AM +0400, Alexey Dobriyan wrote:
> Steps to reproduce:
> 
> 	modprobe tcrypt		# with CONFIG_DEBUG_SG=y

Thanks! I'll push this to Linus.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
