Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZIXMel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZIXMel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZIXMek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZIXMeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:37 -0400
Date: Thu, 24 Sep 2009 14:34:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090924123428.GA27282@elte.hu>
References: <20090924123154.GA12907@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924123154.GA12907@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Ingo,
> 
> Andi asked me this week when we should expect to see the "immediate 
> values" make it into mainline. I remember you pulled them at one 
> point. He would like to use them to encode some very hot-path 
> variables into the instruction stream.
> 
> How should I proceed to get that upstream ? Would a repost be 
> appropriate ?

Would have to see it in full context i guess, with before/after 
measurements, etc.

	Ingo
