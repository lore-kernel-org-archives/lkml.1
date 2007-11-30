Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbXK3UOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbXK3UOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXK3UOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:14:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbXK3UOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:14:16 -0500
Date: Fri, 30 Nov 2007 21:13:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more
	"generic"
Message-ID: <20071130201351.GA8789@elte.hu>
References: <20071128211526.640694725@sgi.com> <20071130111000.GA32431@elte.hu> <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com> <20071130171419.GA18808@elte.hu> <Pine.LNX.4.64.0711300915460.32253@schroedinger.engr.sgi.com> <20071130175825.GA19571@elte.hu> <20071130181206.GA1586@elte.hu> <Pine.LNX.4.64.0711301033580.1806@schroedinger.engr.sgi.com> <20071130184952.GC9928@elte.hu> <Pine.LNX.4.64.0711301117590.2129@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711301117590.2129@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> Ahh this is a UP configuration! [...]

yes, as mentioned in the first sentence of my (tentative) bugreport:

  http://lkml.org/lkml/2007/11/30/78

| i've picked up your cleanup series and this relocation series as well, 
| but it crashed on x86 32-bit UP, with:
                              ^^^^

	Ingo
