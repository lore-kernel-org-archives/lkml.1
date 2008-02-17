Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYBQPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYBQPp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYBQPpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:45:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYBQPpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:45:16 -0500
Date: Sun, 17 Feb 2008 16:45:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: coding style fixes in arch/x86/lib/io_64.c
Message-ID: <20080217154503.GB22132@elte.hu>
References: <20080217144116.5f146cfd@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217144116.5f146cfd@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> [PATCH] x86: coding style fixes in arch/x86/lib/io_64.c
> 
> This simple patch makes the file error free (according to 
> checkpatch.pl)

thanks, applied. (i fixed the other minor style problems in this file 
too, so that we have it all in a single patch)

	Ingo
