Return-Path: <linux-kernel-owner+w=401wt.eu-S1761584AbXE2AlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584AbXE2AlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 20:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXE2AlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 20:41:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4773 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbXE2AlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 20:41:11 -0400
Date: Tue, 29 May 2007 10:39:59 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, nigel@nigel.suspend2.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Message-ID: <20070529003959.GA32543@gondor.apana.org.au>
References: <200705261128.57332.maxi@daemonizer.de> <200705280222.02198.maxi@daemonizer.de> <200705280959.37516.rjw@sisk.pl> <200705282021.30355.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705282021.30355.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 08:21:29PM +0200, Rafael J. Wysocki wrote:
>
> Well, it looks like we have to fix this one separately.
> 
> Can you please tell me what to do to make cryptd run?

If you build it as a module then just loading it should be sufficient.
If you have it built-in then it should always be there.

Let me know when you guys have a final patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
