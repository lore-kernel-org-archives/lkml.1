Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbYEBHem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbYEBHem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762371AbYEBHeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:34:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760897AbYEBHeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:34:10 -0400
Date: Fri, 2 May 2008 09:33:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 2/2] x86_64: use PAGE_OFFSET in dump_pagetables
Message-ID: <20080502073355.GC713@elte.hu>
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com> <1209635899-23018-2-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209635899-23018-2-git-send-email-jirislaby@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Use PAGE_OFFSET macro instead of using 0xffff810000000000UL directly.

thanks Jiri, applied.

	Ingo
