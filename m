Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYBARIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYBARIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYBARIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:08:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42158 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbYBARIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:08:23 -0500
Date: Fri, 1 Feb 2008 18:08:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 0 of 4] x86: cleanups from pmd lifetime series
Message-ID: <20080201170806.GA2159@elte.hu>
References: <patchbomb.1201564120@localhost> <20080201162656.GE15156@elte.hu> <47A34A61.80000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A34A61.80000@goop.org>
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

>> FYI, only this one applied to the latest x86.git tree, could you 
>> please resend? I guess the pgalloc.h related revert interfered.
>
> OK.  I'll do a quick rebase to this morning's tree and resend.

thanks, picked them up, and they just made today's x86.git#mm pushout as 
well.

	Ingo
