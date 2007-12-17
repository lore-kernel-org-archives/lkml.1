Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbXLQQtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbXLQQtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbXLQQtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:49:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbXLQQtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:49:04 -0500
Date: Mon, 17 Dec 2007 17:48:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH] x86: Unify kexec_{32|64}.h
Message-ID: <20071217164843.GA13466@elte.hu>
References: <1197812321.3749.59.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197812321.3749.59.camel@brick>
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

> One section collecting all constant defines.  Ifdef the asm blocks for 
> X86_32/64.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

thanks, applied. Vivek, does it look good to you too?

	Ingo
