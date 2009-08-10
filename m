Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZHJUFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZHJUFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZHJUFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:05:55 -0400
Received: from waste.org ([173.11.57.241]:47871 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZHJUFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:05:54 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2009 16:05:54 EDT
Subject: Re: [PATCH 0/2] New hardware RNG for Octeon SOCs.
From: Matt Mackall <mpm@selenic.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <4A806529.3060609@caviumnetworks.com>
References: <4A806529.3060609@caviumnetworks.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 14:54:54 -0500
Message-Id: <1249934094.3807.32.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 11:21 -0700, David Daney wrote:
> Behold the Random Number Generator driver for Octeon!
> 
> The first patch adds some port definitions and the octeon_rng platform
> device.  The second is the driver.
> 
> I am copying AKPM and Linus as there seems to be no hw_random maintainer.

These now go through Herbert Xu and I.

-- 
http://selenic.com : development and support for Mercurial and Linux


