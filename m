Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYHVJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYHVJFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYHVJFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:05:34 -0400
Received: from mx08.lb01.inode.at ([62.99.145.8]:47321 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750949AbYHVJFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:05:33 -0400
X-Greylist: delayed 93785 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 05:05:33 EDT
Date: Fri, 22 Aug 2008 11:05:23 +0200
From: Sascha Biberhofer <biberhofer@inode.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt LaPlante <kernel1@cyberdogtech.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in authenc: 2.6.26.3
Message-ID: <20080822090523.GA888@aeris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821083615.GA1971@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Sorry, I was skimping on memory and ended up calling a clobbered
> function pointer.
> 
> This patch should fix it.

Works like a charm, thanks for the quick fix. 

  Sascha Biberhofer
