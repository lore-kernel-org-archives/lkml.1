Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbYBTIcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbYBTIcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYBTIcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:32:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbYBTIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:32:34 -0500
Date: Wed, 20 Feb 2008 09:32:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 updates
Message-ID: <20080220083218.GA11830@elte.hu>
References: <alpine.LFD.1.00.0802192357550.7583@apollo.tec.linutronix.de> <20080219155653.4e6bc958.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219155653.4e6bc958.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> What happened to the kernel-doc x86/cpu/mtrr patch, which you applied, 
> according to your email reply...

you can see the latest & greatest arch/x86 patches in the 
x86.git#testing branch. Here is how you can track it:

   http://people.redhat.com/mingo/x86.git/README

your patch was added yesterday so it wasnt in the to-Linus branch of the 
tree yet.

	Ingo
