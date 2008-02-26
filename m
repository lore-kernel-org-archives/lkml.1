Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbYBZJDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbYBZJDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYBZJCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:02:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYBZJCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:02:46 -0500
Date: Tue, 26 Feb 2008 10:02:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>,
       John Levon <levon@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080226090223.GG9857@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <ye8ejb3e8ef.fsf@camel10.daimi.au.dk> <20080226051307.GC17772@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226051307.GC17772@kryten>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> This surprises me. Can you please elaborate on why oprofile is "much 
> less useful" than sysprof?

see the thread you are replying to.

> Anton - who has used oprofile to analyse and tune databases, JVMs,
> 	compilers and operating systems. Maybe I've been missing out on
> 	the killer app for all this time!!!

it's OK if you use it full time and if you are amongst the 0.001% of the 
developer population we call "the best kernel hackers on the planet" ;-) 

It sucks badly if you use it occasionally and have to re-learn its 
non-trivial usage and its quirks every time. As it happens, most 
userspace developers are in this second category.

(and i'm not worried about the first category at all - if needed they 
can write their own OS from scratch ;-)

	Ingo
