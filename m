Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZCDACh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZCDACh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZCDAC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:02:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47114 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754376AbZCDAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:02:28 -0500
Date: Wed, 4 Mar 2009 08:02:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Build fix for ixp4xx_crypto in 2.6.29-rc*
Message-ID: <20090304000216.GA3321@gondor.apana.org.au>
References: <m33adwpuff.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m33adwpuff.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 02:47:32AM +0100, Krzysztof Halasa wrote:
> There is another user of IXP4xx queue manager, fix it.
> 
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

Patch applied to crypto-2.6.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
