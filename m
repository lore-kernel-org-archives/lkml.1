Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbYBANIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbYBANIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759756AbYBANIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:08:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759401AbYBANIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:08:01 -0500
Date: Fri, 1 Feb 2008 14:07:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
Message-ID: <20080201130732.GA1477@elte.hu>
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk> <1201815920-24669-2-git-send-email-ijc@hellion.org.uk> <1201815920-24669-3-git-send-email-ijc@hellion.org.uk> <47A24765.3070300@zytor.com> <1201856568.3804.8.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201856568.3804.8.camel@cthulhu.hellion.org.uk>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> > * Please don't use "unsigned long" to represent a 32-bit number.
> 
> Fixed.

thanks, applied.

	Ingo
