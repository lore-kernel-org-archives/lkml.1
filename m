Return-Path: <linux-kernel-owner+w=401wt.eu-S1422746AbXDRJp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422746AbXDRJp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422748AbXDRJp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:45:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43446 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422745AbXDRJpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:45:25 -0400
Date: Wed, 18 Apr 2007 10:46:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
Message-ID: <20070418104622.177a6cc1@the-village.bc.nu>
In-Reply-To: <4625E5E9.5060100@s5r6.in-berlin.de>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
	<4625E5E9.5060100@s5r6.in-berlin.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 11:33:29 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> John Anthony Kazos Jr. wrote:
> > Convert the subdirectory "crypto" to UTF-8. The files changed are 
> > <crypto/fcrypt.c> and <crypto/api.c>.
> 
> Aren't we using ASCII for C sources?

We haven't done that for many years - it makes it hard to spell some
authors names properly for one.
