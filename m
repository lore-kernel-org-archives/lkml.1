Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZBJGXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZBJGXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 01:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZBJGXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 01:23:22 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49498 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751212AbZBJGXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 01:23:21 -0500
Date: Tue, 10 Feb 2009 17:23:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       frank@f-seidel.de, jarod@redhat.com,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCHv2] crypto: add missing KERN_* constants to printks
Message-ID: <20090210062308.GB19774@gondor.apana.org.au>
References: <498C46DE.8040700@suse.de> <498DA670.1000508@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498DA670.1000508@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 04:19:12PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the crypto subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
