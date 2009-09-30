Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZI3VBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZI3VBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZI3VBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:01:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZI3VBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:01:09 -0400
Date: Wed, 30 Sep 2009 23:00:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090930210054.GD24862@elte.hu>
References: <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <alpine.LFD.2.01.0909301304310.6996@localhost.localdomain> <4AC3BE89.3040708@gmail.com> <alpine.LFD.2.01.0909301339080.6996@localhost.localdomain> <20090930204950.GB24862@elte.hu> <4AC3C562.6080306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AC3C562.6080306@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Ingo Molnar a écrit :
> >> On Wed, 30 Sep 2009, Eric Dumazet wrote:
> >>> Yes, I provided following version in my first answer but apparently 
> >>> it was too complex :)
> > 
> > Yeah, i too missed it while reading through the thread.
> > 
> > 	Ingo
> 
> Well, I was refering to Arjan answer, not Linus/Ingo ones, and Arjan 
> did read my answer and said it was buggy... Its not a problem I dont 
> have 486 here anyway :)

I picked up the improvement that is in your version nevertheless. Even 
if it doesnt matter in practice we dont drop good code :)

> You are all obviously right, I should more carefuly edit mails before 
> hit 'Envoyer' button.

It happens. Since email on lkml is the precursor to real code, one 
should generally treat it with the same high level of taste you treat 
the final code with.

	Ingo
