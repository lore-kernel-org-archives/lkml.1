Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZAVI67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZAVI67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZAVI6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:58:50 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49009 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752908AbZAVI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:58:49 -0500
Date: Thu, 22 Jan 2009 19:58:43 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: fix handling of ccm vectors with null assoc
	data
Message-ID: <20090122085843.GA13088@gondor.apana.org.au>
References: <200901211641.02351.jarod@redhat.com> <20090122010722.GA6937@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122010722.GA6937@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 08:07:22PM -0500, Neil Horman wrote:
>
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> This looks good to me.  Thanks Jarod!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Thanks Jarod!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
