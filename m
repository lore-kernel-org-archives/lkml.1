Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbZCQK4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbZCQK4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZCQK4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:56:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZCQK4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:56:20 -0400
Date: Tue, 17 Mar 2009 11:55:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 1/5] x86, bts: detect size of DS fields
Message-ID: <20090317105558.GK6477@elte.hu>
References: <20090313104218.A30096@sedona.ch.intel.com> <20090313110357.GC31094@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> Apologies for the build fail caused by the incomplete renaming
> in another patch of that series.

the bigger problem is the runtime failure (boot warning) that i 
reported. Hence i cannot apply any new patches yet until that is 
resolved.

	Ingo
