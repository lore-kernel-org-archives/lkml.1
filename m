Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXJFLOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXJFLOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 07:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbXJFLN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 07:13:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbXJFLNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 07:13:55 -0400
Date: Sat, 6 Oct 2007 13:13:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 checkpatch updates, new checkfiles script
Message-ID: <20071006111343.GA29484@elte.hu>
References: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Erez Zadok <ezk@cs.sunysb.edu> wrote:

> So, I ran the above script and it found nearly 1.5 million reported 
> warnings/errors, with drivers being the largest abuser, not 
> surprisingly. [...]

have you tried that with the latest version too:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-next

it outputs far fewer false positives.

	Ingo
