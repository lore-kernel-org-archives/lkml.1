Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYL2OLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYL2OLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYL2OLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYL2OLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:11:09 -0500
Date: Mon, 29 Dec 2008 15:10:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
Message-ID: <20081229141053.GA32075@elte.hu>
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229121218.GB9628@elte.hu> <20081229122251.GA13687@elte.hu> <20081229125411.GA1852@uranus.ravnborg.org> <20081229125921.GB23674@elte.hu> <20081229130133.GA26634@elte.hu> <20081229132541.GB6938@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229132541.GB6938@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > you mean:
> > > 
> > >   git format-patch --stdout -1 -M -B -C <sha1>
> > 
> > also, this does not result in a patch that will be applied properly by 
> > the usual patch-tools that people use when they pick up patches from 
> > email. So i'll just keep my old script ;-)
>
> I sometimes forget about the stoneage....

well applying a (throw-away) patch from email for a specific problem is 
often much handier than to go hunting for git trees and trying to merge 
them or cherry-pick from them. Even for the Git addicted ;-)

	Ingo
