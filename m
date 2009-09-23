Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbZIWM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbZIWM0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZIWM0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:26:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZIWM0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:26:18 -0400
Date: Wed, 23 Sep 2009 14:25:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Jonathan Corbet <corbet@lwn.net>,
       Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
Message-ID: <20090923122530.GB6390@elte.hu>
References: <1253615424.20345.76.camel@Palantir> <1253625878.6575.34.camel@desktop> <20090922173916.257dff1d@tpl.lwn.net> <1253663739.4317.12.camel@desktop> <20090922180611.7a47adcc@tpl.lwn.net> <1253666423.25689.30.camel@desktop> <4ABA0AA6.3010408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA0AA6.3010408@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

>> discouraging contributions is more something that happens when you 
>> get the responses I got earlier in this thread..
>
> That's probably intentional.  Whitespace fixes have their place but 
> not at this stage in a patch's lifecycle.

Exactly. What might make sense is to scan linux-next for new commits 
that show serious cleanliness trouble - and send fix patches to the 
parties involved. That's a real effort and brings the code forward.

	Ingo
