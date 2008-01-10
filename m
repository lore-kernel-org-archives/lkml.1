Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbYAJMp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbYAJMp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYAJMpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:45:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbYAJMpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:45:20 -0500
Date: Thu, 10 Jan 2008 13:44:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: trivial whitespace in kprobes.c
Message-ID: <20080110124458.GC15156@elte.hu>
References: <1199954157.19760.22.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199954157.19760.22.camel@brick>
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

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Ingo, you could/should probably fold this into Masami's kprobe
> unification patch.

i applied this as a separate patch - better for whitespace changes to 
not be mixed into unification patches.

	Ingo
