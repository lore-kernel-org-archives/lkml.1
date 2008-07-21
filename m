Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYGUJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYGUJff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYGUJf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:35:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:58097 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYGUJf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:35:26 -0400
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Reiser <jreiser@BitWagon.com>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com, Nathan Lynch <ntl@pobox.com>
In-Reply-To: <20080720204008.8927460c.akpm@linux-foundation.org>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	 <1216166331-14810-2-git-send-email-ntl@pobox.com>
	 <1216276539.7740.309.camel@pasglop>
	 <20080717000951.5f8cab37.akpm@linux-foundation.org>
	 <20080717221932.GL9594@localdomain>
	 <20080717154218.8981035c.akpm@linux-foundation.org>
	 <487FD74C.4080603@BitWagon.com> <20080718182850.GO9594@localdomain>
	 <1216610655.11027.80.camel@pasglop>
	 <20080720204008.8927460c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 19:33:57 +1000
Message-Id: <1216632837.11027.82.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Andrew, we have one other patch (the powerpc bits) on top of that one.
> > Do you want to carry both in -mm on top of John's patch ? We would like
> > that in .27 though, I don't know what your merge plans are for John's
> > patch.
> > 
> 
> How about I send John's patch Linuswards right now?

No objection.

Cheers,
Ben.


