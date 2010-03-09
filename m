Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0CIHaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:30:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55717 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0CIHaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:30:06 -0500
Date: Tue, 9 Mar 2010 08:29:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100309072938.GA6137@elte.hu>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <20100308190857.400bde09@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
 <20100308192744.5f40a5ee@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003081132370.3989@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003081132370.3989@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 8 Mar 2010, Alan Cox wrote:
> > 
> > man restorecond
> 
> I know. I also sometimes sit through minutes of "let's relabel the system, 
> because you've booted a kernel without selinux support".

I've had selinux relabeling wait times of an hour or two too, on a 
sufficiently large filesystem.

I think this hurts security far more than anything else, because it causes 
people to actually _turn off the whole thing_ - so we will have less and less 
security in the end.

( To use the obligatory fire door analogy: we should prefer a one inch thick 
  fire door that opens and closes fully automated to a five inches thick fire 
  door that people keep always-open with a chair. )

	Ingo
