Return-Path: <linux-kernel-owner+w=401wt.eu-S1030828AbXCHWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030828AbXCHWn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030827AbXCHWn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:43:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030828AbXCHWn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:43:57 -0500
Date: Thu, 8 Mar 2007 23:42:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
Message-ID: <20070308224223.GD30113@elte.hu>
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0761C.6060107@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> [...]  So it is a little late to tell us - "redesign your hypervisor, 
> or else.."

is this how long the "paravirt_ops hides all the details and the VMI 
hypervisor ABI will never hinder Linux" sham lasted? Now that your stuff 
is upstream barely 2 weeks you say that it needs a redesign of your 
hypervisor to implement our suggestions? And your argument is: "oops, 
we've got product plans, too late for that, sorry"?

_we_ have to live with that mess for years, and part of our job is to 
say 'NO' when we see mess coming up. And no, it's not our job to solve 
it for you.

	Ingo
