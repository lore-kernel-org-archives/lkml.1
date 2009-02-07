Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZBGOOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZBGOOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 09:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZBGONy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 09:13:54 -0500
Received: from ns.suse.de ([195.135.220.2]:52159 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZBGONy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 09:13:54 -0500
Message-ID: <498D9706.9090209@suse.de>
Date: Sat, 07 Feb 2009 15:13:26 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Frank Seidel <frank@f-seidel.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       jarod@redhat.com
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain> <498C4F2E.1070204@f-seidel.de> <20090206150315.GA28249@x200.localdomain> <498C5053.4010809@suse.de> <20090207125211.GA17913@gondor.apana.org.au>
In-Reply-To: <20090207125211.GA17913@gondor.apana.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Please do.  If it doesn't have any markings at least we know that
> it needs fixing.  If you just add WARNINGs then we lose that
> information.

Thats right, i fully agree. So i'll redo it asap.

Thanks,
Frank
