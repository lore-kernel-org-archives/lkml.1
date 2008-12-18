Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYLRWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYLRWhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYLRWhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:37:09 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:60379 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752371AbYLRWhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:37:06 -0500
Date: Fri, 19 Dec 2008 09:36:51 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
Message-ID: <20081218223651.GA1574@gondor.apana.org.au>
References: <1229638581.3726.546.camel@calx> <Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:33:46PM +0000, Ilpo Järvinen wrote:
> 
> Last time (well, ignoring some report on ancient vendor kernel) I've seen 
> this to trigger it wasn't the fault of the peer but ours (we sent past the 
> advertized window and window ended up being shrunk to zero). I agree that 
> the message as-is is not very good but your change is not very good 
> either.

Indeed I had fixed a bug in our kernel that triggered this too
so this is definitely treason :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
