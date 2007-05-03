Return-Path: <linux-kernel-owner+w=401wt.eu-S1031178AbXECMNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031178AbXECMNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031047AbXECMNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:13:37 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:44618 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030949AbXECMNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:13:36 -0400
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 08:13:36 EDT
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
	<20070502044345.GA29384@gondor.apana.org.au>
	<alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: 03 May 2007 13:53:16 +0200
In-Reply-To: <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
Message-ID: <87r6pyqg2b.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:
> Did this file individually, per request. Will re-do the whole tree later 
> as I'm still working on my handy-dandy testing and patching tools and 
> don't have a lot of time outside of work until the summer gets underway.

While this is probably inevitable, it would be nice if there was some
way to determine the actual coding system used for individual files.
Especially if we're mixing latin1 and utf8 in the same tree.  Has
something like adding "/* -*- coding: utf-8; -*- */" or similar to the
top of converted files been considered?

-- 
								Arne.

