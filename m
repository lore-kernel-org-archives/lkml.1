Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYCYIwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYCYIwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYCYIvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:51:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbYCYIvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:51:50 -0400
Date: Tue, 25 Mar 2008 09:51:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/148] include/asm-x86/acpi.h: checkpatch cleanups -
	formatting only
Message-ID: <20080325085134.GA813@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com> <1206259443-13210-2-git-send-email-joe@perches.com> <20080323.031345.131361984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323.031345.131361984.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> Please do not post 148 patches all at once.

seconded - i asked Joe to offer such cleanups in a git tree. Given that 
most of the changes in the patches are along the same pattern, posting 
the script would have made more sense as well.

while we do have a growing code quality problem, spamming our lists with 
trivialities is certainly not the answer.

	Ingo
