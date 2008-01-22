Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYAVL36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYAVL36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 06:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYAVL3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 06:29:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56312 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYAVL3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 06:29:51 -0500
Date: Tue, 22 Jan 2008 12:29:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/3] x86: Unify page fault oops printing
Message-ID: <20080122112935.GE26634@elte.hu>
References: <1200956283.16972.41.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200956283.16972.41.camel@brick>
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

> This changes the oops dumping format for page faults to be similar 
> between X86_32 and 64.
> 
> This is the first user of printk_address on X86_32.

could you please send an actual before/after dump, so that we can see 
the behavioral changes?

	Ingo
