Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYBAONZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYBAONZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYBAONT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:13:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46459 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYBAONS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:13:18 -0500
Date: Fri, 1 Feb 2008 15:12:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel BUG while bootup
Message-ID: <20080201141251.GA25080@elte.hu>
References: <20080122135800.GA6084@in.ibm.com> <20080122155329.GA30119@elte.hu> <20080128145722.GB25517@in.ibm.com> <20080128151300.GB12205@elte.hu> <20080131140223.GA6568@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131140223.GA6568@in.ibm.com>
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


* Sudhir Kumar <skumar@linux.vnet.ibm.com> wrote:

> >    http://redhat.com/~mingo/x86.git/README
> > 
> > does that crash too?
> 
> Sorry , unable to do that as the instrunctions at above location do 
> not work. Something else I can try ?

hm, those instructions work fine here, if i do them anew. It ends 
with:

 earth4:~/tmp/linux.trees.git> git-checkout x86/mm
 warning: You appear to be on a branch yet to be born.
 warning: Forcing checkout of x86/mm.
 ...
 HEAD is now at 063f7f2... kgdb: cleanups

i've got git-core-1.5.3.8-1.fc8.

	Ingo
