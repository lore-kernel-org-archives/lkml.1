Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbXFQPQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbXFQPQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbXFQPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:16:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbXFQPQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:16:41 -0400
Date: Sun, 17 Jun 2007 17:16:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       "Darrick J. Wong" <djwong@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Message-ID: <20070617151612.GB11762@elte.hu>
References: <467543FA.60905@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467543FA.60905@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject    : long freezes on thinkpad t60
> References : http://lkml.org/lkml/2007/5/24/100
> Submitter  : Miklos Szeredi <miklos@szeredi.hu>
> Handled-By : Ingo Molnar <mingo@elte.hu>
> Patch      : http://lkml.org/lkml/2007/6/16/81
> Status     : patch was suggested

i think this isnt a new regression in .22, it existed in .21 too - or 
are you tracking all 2.6 regressions?

	Ingo
