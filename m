Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZAHMKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZAHMKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZAHMKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:10:41 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51089 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753026AbZAHMKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:10:39 -0500
Date: Thu, 8 Jan 2009 23:10:27 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: alan@lxorguk.ukuu.org.uk
Cc: michael@laptop.org, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090108121027.GA3226@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> That to me says controlling network access is only useful as part of a
> more fine grained and general purpose interface. We already have that
> interface in the form of things like SELinux. We already have systems
> actively using it to control stuff like which ports are accessed by some
> services.

Exactly.  If people want this they should go the SELinux/LSM route.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
