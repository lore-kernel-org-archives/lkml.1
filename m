Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZCHUdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZCHUdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 16:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZCHUdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 16:33:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZCHUdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 16:33:13 -0400
Date: Sun, 8 Mar 2009 21:32:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org, tglx@linutronix.de,
       Vegard Nossum <vegard.nossum@gmail.com>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:kmemcheck] x86: introduce bootmem_state
Message-ID: <20090308203236.GA14913@elte.hu>
References: <49B1C47C.5080401@kernel.org> <tip-4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e@git.kernel.org> <20090308185834.GD28169@elte.hu> <86802c440903081230y4abc548m16bb722863ea0b1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440903081230y4abc548m16bb722863ea0b1a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Mar 8, 2009 at 11:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >> Commit-ID:  4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
> >> Gitweb:     http://git.kernel.org/tip/4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
> >> Author:     "Yinghai Lu" <yinghai@kernel.org>
> >> AuthorDate: Fri, 6 Mar 2009 16:49:00 -0800
> >> Commit:     Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Sun, 8 Mar 2009 19:43:09 +0100
> >>
> >> x86: introduce bootmem_state
> >>
> >> Impact: cleanup
> >
> > Note, this cleanup ended up in the tip:kmemcheck branch because
> > it modifies the same code so there's dependencies.
> 
> not sure. it seems it should be with tip/x86/mm

kmemcheck has the latest changes to that area and it has x86/mm 
merged too.

	Ingo
