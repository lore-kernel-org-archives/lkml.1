Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZHJWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZHJWfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZHJWfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:35:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbZHJWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:35:48 -0400
Date: Mon, 10 Aug 2009 15:34:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: ralf@linux-mips.org, torvalds@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] New hardware RNG for Octeon SOCs.
Message-Id: <20090810153438.542f55e0.akpm@linux-foundation.org>
In-Reply-To: <4A806529.3060609@caviumnetworks.com>
References: <4A806529.3060609@caviumnetworks.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 11:21:29 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> Behold the Random Number Generator driver for Octeon!

Hail!

> The first patch adds some port definitions and the octeon_rng platform
> device.  The second is the driver.
> 
> I am copying AKPM and Linus as there seems to be no hw_random maintainer.
> 
> Since Octeon is a mips port, we might want to merge both patches via
> Ralf's tree.
> 
> Comments?

Looks OK to me - I had a couple of minor comments.  Please send the
patches to Herbert and Ralf - I'd normally expect one of those two
gents to be the merge path for this work.

