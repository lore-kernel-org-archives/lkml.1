Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZEDLYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZEDLYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZEDLY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:24:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43382 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbZEDLY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:24:29 -0400
Date: Mon, 4 May 2009 19:24:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH v4 0/2] crypto: add testmgr support and self-tests for
	rfc4309
Message-ID: <20090504112422.GA5264@gondor.apana.org.au>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150937.11979.jarod@redhat.com> <20090420062640.GB1135@gondor.apana.org.au> <49F0B09D.6040308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F0B09D.6040308@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 02:17:01PM -0400, Jarod Wilson wrote:
> These patches add necessary infrastructure additions to testmgr/tcrypt
> to support the inclusion of rfc4309(ccm(aes)) self-tests, and the
> rfc4309 test vectors themselves.
> 
> [PATCH 1/2] crypto: handle ccm dec test vectors expected to fail verification
> [PATCH 2/2] crypto: add self-tests for rfc4309(ccm(aes))

Both patches applied.  Thanks a lot Jarod!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
