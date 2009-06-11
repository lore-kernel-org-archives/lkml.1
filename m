Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZFKTGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZFKTGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZFKTGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:06:02 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47910 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZFKTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:06:00 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>
	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
	 <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com>
	 <4A3148AA.9000007@davidnewall.com>
	 <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 21:05:58 +0200
Message-Id: <1244747158.27363.59.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > What I'm saying is that this doesn't sound like something that needs
> > user-space in lock-step with kernel.
> 
> Give it a rest.
> 
> If that's true, then in a year or two we can just split it up already.
> 
> But I note (once more) how _nobody_ has actually been able to accept the 
> fact that oprofile was an abject failure as it was split up. Instead, you 
> all dance around totally irrelevant issues.

so your whole reasoning is based on the fact that oprofile was a
horrible failure. All the other projects/subsystems that manage this
perfectly successful without breaking API/ABI abruptly and emerging
slowly when things change don't count. Stop dancing around oprofile so
much. It makes you dizzy ;)

Regards

Marcel


