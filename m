Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZHXHsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZHXHsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZHXHsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:48:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:44189 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbZHXHsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:48:11 -0400
Date: Mon, 24 Aug 2009 17:47:30 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Daney <ddaney@caviumnetworks.com>
Cc: ralf@linux-mips.org, mpm@selenic.com, linux-mips@linux-mips.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: Octeon:  Add hardware RNG platform device.
Message-ID: <20090824074730.GA32067@gondor.apana.org.au>
References: <4A8DBB17.5020301@caviumnetworks.com> <1250802623-6526-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250802623-6526-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 02:10:22PM -0700, David Daney wrote:
> Add a platform device for the Octeon Random Number Generator (RNG).
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
