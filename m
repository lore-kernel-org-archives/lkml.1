Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXHERww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXHERww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXHERwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:52:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59304 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbXHERwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:52:33 -0400
Date: Sun, 5 Aug 2007 19:51:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Jan Dittmer <jdi@l4x.org>,
       Thomas Renninger <trenn@suse.de>, Netdev <netdev@vger.kernel.org>,
       Joachim Deguara <joachim.deguara@amd.com>,
       Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, Seokmann Ju <seokmann.ju@qlogic.com>,
       Richard Lary <rlary@us.ibm.com>
Subject: Re: [2/2] 2.6.23-rc2: known regressions with patches
Message-ID: <20070805175155.GA3244@elte.hu>
References: <46B5F93A.1020100@googlemail.com> <46B5FA4C.2070700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B5FA4C.2070700@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Memory management
> 
> Subject         : [bug] SLUB & freeing locks
> References      : http://lkml.org/lkml/2007/7/26/90
> Last known good : ?
> Submitter       : Ingo Molnar <mingo@elte.hu>
> Caused-By       : ?
> Handled-By      : Peter Zijlstra <peterz@infradead.org>
> Patch           : http://lkml.org/lkml/2007/7/26/97
> Status          : patch available

fixed by commit 2208b764c14d0f1ad63da64b1a42db6077b6fe42.

	Ingo
