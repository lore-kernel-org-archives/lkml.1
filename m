Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbYCaOvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbYCaOvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYCaOkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:40:06 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:15325 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYCaOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:40:04 -0400
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
In-Reply-To: <20080331142111.GB14688@gondor.apana.org.au>
References: <20080314092523.147382820@de.ibm.com>
	 <20080314093046.914555041@de.ibm.com>
	 <20080331142111.GB14688@gondor.apana.org.au>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 31 Mar 2008 16:39:23 +0200
Message-Id: <1206974363.26149.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 22:21 +0800, Herbert Xu wrote:
> > This patch allows user space applications to access large amounts of 
> > truly random data. The random data source is the build-in hardware 
> > random number generator on the CEX2C cards.
> > 
> > Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The patch looks OK.
> 
> Are you guys going to carry this patch in the s390 tree?

Yes, this patch should go in over git390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


