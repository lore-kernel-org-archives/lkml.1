Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZGVKNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZGVKNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZGVKNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:13:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:57346 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbZGVKNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:13:05 -0400
Subject: Re: [PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch list <linux-arch@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <23069.1248250174@redhat.com>
References: <1248241468.27348.47.camel@pasglop>
	 <23069.1248250174@redhat.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 20:12:15 +1000
Message-Id: <1248257535.27348.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 09:09 +0100, David Howells wrote:
> > Martin Schwidefsky compile tested on s390 and Michael Ellerman did
> some
> > test builds on ia64, arm, sparc32, sparc64, i386 and x86_64
> > 
> > Nobody else reacted.
> 
> I did tests for MN10300 and FRV.
> 
Ah yes, I did put you in the acked-by's and didn't think about
mentioning you again in the little blurb at the end !

Thanks for testing btw.

Cheers,
Ben.


