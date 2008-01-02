Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbYABQJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbYABQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYABQJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:09:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbYABQJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:09:45 -0500
Date: Wed, 2 Jan 2008 17:09:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: introduce force_sig_info_fault helper to X86_64
Message-ID: <20080102160934.GD21046@elte.hu>
References: <1199280815.6323.68.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199280815.6323.68.camel@brick>
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

> Use the force_sig_info_fault helper from X86_32 in X86_64.

thanks, applied.

	Ingo
