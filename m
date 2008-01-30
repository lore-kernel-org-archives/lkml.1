Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbYA3VyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbYA3VyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYA3VyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:54:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYA3VyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:54:01 -0500
Date: Wed, 30 Jan 2008 22:53:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 6/6] s390: Use generic percpu linux-2.6.git
Message-ID: <20080130215339.GC28242@elte.hu>
References: <20080130180940.022172000@sgi.com> <20080130180940.921597000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130180940.921597000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> Change s390 percpu.h to use asm-generic/percpu.h

do the s390 maintainer agree with this change (Acks please), and has it 
been tested on s390?

	Ingo
