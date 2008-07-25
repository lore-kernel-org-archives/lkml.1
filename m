Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYGYBZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYGYBZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYGYBYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:24:53 -0400
Received: from ozlabs.org ([203.10.76.45]:35071 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYGYBYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:24:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PULL] lguest and virtio patches
Date: Fri, 25 Jul 2008 11:24:48 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Johannes Weiner <hannes@saeurebad.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200807231727.35138.rusty@rustcorp.com.au> <1216915133.19183.5.camel@muff>
In-Reply-To: <1216915133.19183.5.camel@muff>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251124.49251.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008 01:58:53 Mark McLoughlin wrote:
> >       virtio: Add transport feature handling stub for virtio_ring.
>
> This last one introduces a compile failure; fixup patch below.

Thanks, rolled.

Checking, will re-send.

Rusty.
