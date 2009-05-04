Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZEDLvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZEDLvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZEDLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:51:45 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:49570 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601AbZEDLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:51:45 -0400
Date: Mon, 4 May 2009 19:51:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto: print self-test pass notices in fips mode
Message-ID: <20090504115142.GC5445@gondor.apana.org.au>
References: <200904282121.35300.jarod@redhat.com> <200904290921.54483.jarod@redhat.com> <200904290924.11005.jarod@redhat.com> <200904301725.06671.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301725.06671.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 05:25:05PM -0400, Jarod Wilson wrote:
> 
> According to our FIPS CAVS testing lab guru, when we're in fips mode,
> we must print out notices of successful self-test completion for
> every alg to be compliant.

Also applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
