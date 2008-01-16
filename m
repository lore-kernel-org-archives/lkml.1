Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbYAPGw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbYAPGw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 01:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYAPGwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 01:52:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:13082 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYAPGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 01:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tC5bL2qXsIM+JjEY0nYbBj4T1w5hxF37f8CUVY5QHaDf0wx5I8GYnsn32atvlxzwk7wU/u3i0DMucH7teQn+TX1XdKEXCb+OcMzsymTXCDp+s/jOE/1VQTTR8c9m2OHfSeMoacpr1WKL6B82z3519IAt6irEn8eBOnU5vnVXs0I=
Date: Wed, 16 Jan 2008 07:58:36 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: cfriesen@nortel.com, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network
	packets
Message-ID: <20080116065836.GA1638@ff.dom.local>
References: <20080115202905.GA2680@ami.dom.local> <E1JEvxs-0006cZ-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JEvxs-0006cZ-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:17:08AM +1100, Herbert Xu wrote:
...
> Well people are always going to operate on this model for commercial
> reasons.  FWIW I used to work for a company that stuck to a specific
> version of the Linux kernel, and I suppose I still do even now :)
> 
> But the important thing is that if you're going to do that, then the
> cost that comes with it should be borne by the company and not the
> community.

Sure. But the most sad thing is there seems to be not so much savings
in this (unless a company isn't sure of its near future). Trying to
upgrade and test current products with current kernels, even if not
necessary, should be always useful and make developing of new products
faster and better fit (and of course, BTW, make the kernel better on
time).

Regards,
Jarek P.
