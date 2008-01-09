Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYAIQNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYAIQNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYAIQNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:13:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYAIQNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:13:41 -0500
Date: Wed, 9 Jan 2008 17:13:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: More users of PF_ constants in fault_32|64.c
Message-ID: <20080109161329.GC17739@elte.hu>
References: <1199839734.6424.19.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199839734.6424.19.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Should be the last of the error_code tests that could use the PF_ 
> defines.  Makes X86_32|64 a little closer.

thanks, applied.

	Ingo
