Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYCDIRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYCDIRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYCDIRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:17:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYCDIRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:17:21 -0500
Date: Tue, 4 Mar 2008 09:16:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Avi Kivity <avi@qumranet.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: replace remaining __FUNCTION__ occurances
Message-ID: <20080304081658.GB5689@elte.hu>
References: <1204573043.3266.50.camel@brick> <47CC6422.5030806@qumranet.com> <1204577802.22933.6.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204577802.22933.6.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> > Please send the kvm parts against kvm.git instead of mainline to 
> > avoid needless merges.
> 
> Sure, I'll send a split out patch against kvm.git
> 
> Ingo, do you mind chopping the diff to apply just the x86-specific 
> stuff or do you want a split patch as well?

no need, i picked up the non-kvm bits. Avi, will you pick up the KVM 
bits or should Harvey resend?

	Ingo
