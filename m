Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYAUAI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYAUAI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYAUAIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:08:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbYAUAIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:08:46 -0500
Date: Mon, 21 Jan 2008 01:08:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: add vdso32-int80-syms.lds to .gitignore
Message-ID: <20080121000835.GC2259@elte.hu>
References: <1200867412.5724.203.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200867412.5724.203.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> One of the generated files was missed in gitignore

thanks, applied.

	Ingo
