Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXLCRLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXLCRLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXLCRLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:11:12 -0500
Received: from ns.suse.de ([195.135.220.2]:44980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbXLCRLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:11:11 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Markus Metzger <markus.t.metzger@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
From: Andi Kleen <andi@firstfloor.org>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com>
	<20071201074044.GA13974@elte.hu>
	<a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com>
	<200712031721.39013.ak@suse.de> <20071203164506.GA16135@elte.hu>
Date: Mon, 03 Dec 2007 18:11:09 +0100
In-Reply-To: <20071203164506.GA16135@elte.hu> (Ingo Molnar's message of "Mon\, 3 Dec 2007 17\:45\:06 +0100")
Message-ID: <p73ir3fwvo2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Andi Kleen <ak@suse.de> wrote:
>
>> Just don't wait for that. utrace doesn't seem to have any concrete 
>> plans to merge any time soon AFAIK[1] and it would be a shame to delay 
>> an useful feature forever.
>> 
>> [1] At least the patches have not reached any mailing lists
>
> FYI, as far as arch/x86 goes, the merging of Roland's utrace preparatory 
> patches is well underway in x86.git, and the merge went pretty well so 
> far, with robust results. It's 49 patches so far:

I see. They are planning to just skip the public review stage?  Clever.

-Andi
