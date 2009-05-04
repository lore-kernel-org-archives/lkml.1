Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZEDLuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZEDLuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZEDLty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:49:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:39758 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbZEDLtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:49:53 -0400
Date: Mon, 4 May 2009 19:49:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto: catch base cipher self-test failures in
	fips mode
Message-ID: <20090504114952.GB5445@gondor.apana.org.au>
References: <200904282111.52074.jarod@redhat.com> <20090429132646.GA17481@gondor.apana.org.au> <200904290934.32404.jarod@redhat.com> <200904301621.57298.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301621.57298.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 04:21:56PM -0400, Jarod Wilson wrote:
> 
> Version 2, streamlined and simplified, RHEL5 be damned.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
