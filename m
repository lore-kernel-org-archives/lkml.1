Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZBRXOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZBRXOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZBRXOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:14:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZBRXOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:14:35 -0500
Date: Thu, 19 Feb 2009 00:13:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/9] Make lazy mmu update mode pre-empt safe
Message-ID: <20090218231352.GB13323@elte.hu>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com> <cover.1234988621.git.jeremy.fitzhardinge@citrix.com> <499C9116.7000702@goop.org> <20090218225534.GA24717@elte.hu> <499C93E1.20104@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C93E1.20104@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Are you using "git format-patch" and "git send-email" ?
>
> Yes.
>
>>  Then perhaps the --compose option to git-send-email is what you are  
>> after?
>
> I'm pre-editing the 0000-cover.patch - but it looks like its picking up  
> the 0000-cover.patch~ file in preference to 0000-cover.patch.  I think.

try test-sending to yourself until it works :-)

	Ingo
