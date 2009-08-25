Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZHYTYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZHYTYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZHYTYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:24:40 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:33561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755995AbZHYTYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:24:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
X-Fcc: ~/Mail/linus
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: Rusty Russell's message of  Tuesday, 25 August 2009 17:29:32 +0930 <200908251729.32855.rusty@rustcorp.com.au>
References: <4A89CC4D.5040801@gmx.de>
	<20090819013124.7539E4730F@magilla.sf.frob.com>
	<1250645916.18426.12.camel@mulgrave.site>
	<200908251729.32855.rusty@rustcorp.com.au>
X-Shopping-List: (1) Psychic inflammations
   (2) Fermented wine
   (3) Indulgent frivolity cows
Message-Id: <20090825192432.4D9CC411E3@magilla.sf.frob.com>
Date: Tue, 25 Aug 2009 12:24:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, x86 was one of the archs which fucked us.  Richard Henderson and
> I *had* this, but ld -shared without -fPIC helpfully tells you "you're doing
> it wrong" on x86-64.

This complaint could easily be (have been) made optional.

> There were other issues, ISTR MIPS was a showstopper.

Richard told me it's all MIPS' fault, but I was being discreet.


Thanks,
Roland
