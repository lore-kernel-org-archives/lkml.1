Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYDNJqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYDNJqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYDNJqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:46:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYDNJqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:46:30 -0400
Date: Mon, 14 Apr 2008 11:46:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] x86: Cleanup prose of Documentation/i386/IO-APIC.txt
Message-ID: <20080414094603.GB3761@elte.hu>
References: <20080411154053.GD18242@tull.net> <20080413084536.GB24429@elte.hu> <20080413112522.GD29599@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413112522.GD29599@tull.net>
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> > Btw., that's rather arcane text - do people still have to use pirq= 
> > boot lines to get their boxes to boot?
> 
> I wouldn't know that, but I still have to use 'noapic' to get my AMD 
> box to boot :-(

oh. If "noapic" is still necessary with x86/latest:

  http://people.redhat.com/mingo/x86.git/README

is there any bugreport i could have a look at, with full dmesg and 
config included, and with a description of how it fails to boot? 
cfs-debug-info output would be useful too:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

	Ingo
