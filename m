Return-Path: <linux-kernel-owner+w=401wt.eu-S1761014AbXFDVdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014AbXFDVdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXFDVd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:33:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1196 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbXFDVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:33:28 -0400
Date: Tue, 5 Jun 2007 07:33:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] the ASYNC_* options shouldn't be user visible
Message-ID: <20070604213305.GA6852@gondor.apana.org.au>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201F0351F@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201F0351F@azsmsx413.amr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:25:02AM -0700, Williams, Dan J wrote:
> 
> Herbert can I move async_tx under crypto since the engines I am working
> with have support for algorithms like CRC32C and Galois Field Multiply
> (raid6 p+q)?

Sure that's fine by me.  Although as Adrian said it's probably better
to use something other than alphabetical order :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
