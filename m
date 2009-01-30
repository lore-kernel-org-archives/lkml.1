Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZA3HGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZA3HGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZA3HGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:06:01 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53392 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751931AbZA3HGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:06:00 -0500
Date: Fri, 30 Jan 2009 18:05:56 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: arrow.ebd@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: ipv6: INFO: possible circular locking dependency detected --
	2.6.29-rc3
Message-ID: <20090130070556.GA4977@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129124328.GA21638@think>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arrow.ebd@gmail.com wrote:
> 
>        Here is some error message when I starting gw6c, but work fine
> after try again.

Please see

http://bugzilla.kernel.org/show_bug.cgi?id=12515
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
