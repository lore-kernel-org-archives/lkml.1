Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYAVLaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYAVLaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 06:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYAVLaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 06:30:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYAVLaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 06:30:03 -0500
Date: Tue, 22 Jan 2008 12:29:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] x86: Introduce show_fault_oops helper to
	fault_32|64.c
Message-ID: <20080122112948.GF26634@elte.hu>
References: <1200956281.16972.40.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200956281.16972.40.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> This will help when unifying the oops dumping code on 32/64 bit.  No 
> functional changes.

thanks, applied.

	Ingo
