Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXHAGHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXHAGHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXHAGGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:06:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXHAGGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:06:54 -0400
Date: Wed, 1 Aug 2007 08:06:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] Move RECURSION_LIMIT define up for more global use
	(take 2)
Message-ID: <20070801060605.GA6382@elte.hu>
References: <Pine.LNX.4.58.0707312315210.10742@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707312315210.10742@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> OK, I sent this out once before but it must have slipped under the 
> radar. http://lkml.org/lkml/2007/6/28/325

thanks - applied.

	Ingo
