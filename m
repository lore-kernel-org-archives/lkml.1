Return-Path: <linux-kernel-owner+w=401wt.eu-S1765228AbYBTPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765228AbYBTPsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYBTPrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:47:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYBTPrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:47:48 -0500
Date: Wed, 20 Feb 2008 16:46:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ftrace causing panics.
Message-ID: <20080220154659.GA27901@elte.hu>
References: <20080219124222.GB13780@linux.vnet.ibm.com> <20080219140352.GB9965@elte.hu> <20080219155433.GA4754@linux.vnet.ibm.com> <20080219161608.GA1347@elte.hu> <20080219173839.GF4754@linux.vnet.ibm.com> <47BC40FA.6020205@redhat.com> <20080220152815.GB1082@linux.vnet.ibm.com> <47BC4A68.5050704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC4A68.5050704@redhat.com>
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


* Steven Rostedt <srostedt@redhat.com> wrote:

>> sched-devel as of yesterday. (I don't think anything new has gone in 
>> today).
>
> I just sent Ingo my fixes a few minutes ago. You may want to keep an I 
> out on updates to sched-devel.

it's now all up in sched-devel.git.

	Ingo
