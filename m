Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYC1WFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYC1WFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbYC1WFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:05:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbYC1WFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:05:30 -0400
Date: Fri, 28 Mar 2008 23:04:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] [RFC] hotplug memory: minor updates
Message-ID: <20080328220436.GI2016@elte.hu>
References: <patchbomb.1206664116@localhost> <20080328091250.GH21413@elte.hu> <47ED17AF.5030804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ED17AF.5030804@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> the x86 bits look small and trivial, so i'd suggest you get this into 
>> -mm to after all the other VM patches, because this seems primarily a 
>> VM issue.
>
> I would do that, but I'm planning on posting some Xen balloon driver 
> patches which depend on at least one of these patches.

ok. Will wait patiently then :)

	Ingo
