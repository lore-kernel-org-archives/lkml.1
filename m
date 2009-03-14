Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZCNQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZCNQk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZCNQkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:40:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZCNQkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:40:13 -0400
Date: Sat, 14 Mar 2009 17:39:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090314163944.GA31930@elte.hu>
References: <20090314122434.GA14521@elte.hu> <Pine.LNX.4.44L0.0903141157320.8138-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903141157320.8138-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> So in the end, you're _agreeing_ with what I wrote.  And yet 
> the tone of your reply suggests that you seemed to think that 
> my message had some deep, hostile intent.  It didn't.

Sorry about that - i didnt mean to convey any such message.

I guess i'll wait for the next series. All i'm striving for is 
for the whole series to be a lot simpler than what i've seen 
before.

	Ingo
