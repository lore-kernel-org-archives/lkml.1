Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYBAQ1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYBAQ1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYBAQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:27:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbYBAQ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:27:33 -0500
Date: Fri, 1 Feb 2008 17:26:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 0 of 4] x86: cleanups from pmd lifetime series
Message-ID: <20080201162656.GE15156@elte.hu>
References: <patchbomb.1201564120@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1201564120@localhost>
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

> Hi Ingo,
> 
> Here's a followup set from that last batch of patches:
>  1. fix up the pgd_ctor merge, so that non-PAE will end up getting
>     kernel mappings

FYI, only this one applied to the latest x86.git tree, could you please 
resend? I guess the pgalloc.h related revert interfered.

	Ingo
