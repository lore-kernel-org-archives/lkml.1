Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYAOKBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYAOKBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYAOKBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:01:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbYAOKBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:01:42 -0500
Date: Tue, 15 Jan 2008 11:01:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: sam@ravnborg.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Latest git-x86 doesn't build on 32bit
Message-ID: <20080115100130.GA27029@elte.hu>
References: <20080114221608.GA11732@basil.nowhere.org> <20080115085757.GA18591@elte.hu> <20080115090829.GB29301@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115090829.GB29301@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Jan 15, 2008 at 09:57:57AM +0100, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > On a fresh object dir I get for a 32bit build:
> > 
> > you seem to have a modified git repository.
> 
> Would surprise me -- i regularly remove the old one and reclone fresh.
> 
> Also didn't other people complain about build problems too?

not that i know of. (Got reports about the "only half of x86.git got 
uploaded last night" problem but that is distinct.)

> Anyways I'll try today's git now.

ok.

	Ingo
