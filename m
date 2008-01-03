Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYACH6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYACH6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYACH6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:58:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYACH6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:58:08 -0500
Date: Thu, 3 Jan 2008 08:57:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
Subject: Re: git-x86 broken on 32bit
Message-ID: <20080103075758.GA2351@elte.hu>
References: <200801030111.40061.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801030111.40061.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Current git-x86 seems to be totally broken on i386 
> 
> commit a6f08929f0566f9d309ef5f6651371d8e20fc833
> Author: Russell Leidich <rml@google.com>
> Date:   Wed Jan 2 22:46:22 2008 +0100

that patch was not included in x86.git anymore at the time you wrote 
your email. You probably picked up an interim version of the queue that 
had the breakage - i noticed it and pulled it a few minutes later.

	Ingo
