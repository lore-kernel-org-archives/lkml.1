Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZEMXqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZEMXqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762097AbZEMXp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:45:56 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43652 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762085AbZEMXpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:45:55 -0400
Date: Thu, 14 May 2009 09:45:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Message-ID: <20090513234550.GA24792@gondor.apana.org.au>
References: <200905111006.32675.jarod@redhat.com> <20090513132752.GA17262@gondor.apana.org.au> <20090513140224.GB16406@hmsreliant.think-freely.org> <200905131253.16977.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905131253.16977.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:53:16PM -0400, Jarod Wilson wrote:
> 
> It would likely need a LOT of polish, and I'm not sure if its at all
> close to what we have (Herbert has?) in mind.... At the moment, it
> consists of:

The interface I had in mind can be found in the recent discussions
in the linux-crypto archives.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
