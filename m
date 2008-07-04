Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYGDLuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYGDLuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYGDLtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:49:55 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:40885 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752464AbYGDLtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:49:55 -0400
Date: Fri, 4 Jul 2008 19:49:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: rmd160.c rmd256.c rmd320.c sparse annotations
Message-ID: <20080704114936.GA6325@gondor.apana.org.au>
References: <1215120642.16647.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215120642.16647.26.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:30:42PM -0700, Harvey Harrison wrote:
> Similar to the rmd128.c annotations, significantly cuts down on the
> noise.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

All applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
