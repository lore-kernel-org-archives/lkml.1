Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYCSWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYCSWP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYCSUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:45:43 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:36368 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761933AbYCSUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:45:35 -0400
X-Greylist: delayed 1934 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 16:45:35 EDT
Date: Wed, 19 Mar 2008 20:05:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080319190536.GA11432@elte.hu>
References: <patchbomb.1205797011@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1205797011@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This is a great big pile of x86 unification and Xen bugfix patches. 
> They build and boot for me on 64-bit and 32-bit (PAE and non-PAE).
> 
> Patches are based on x86.git#testing as of this morning.
> 
> The overview:
> 
>  - a couple of Xen bugfixes, which are 2.6.24 and 2.6.25 material
>  - a bunch of x86 cleanups and unifications, mostly around pgalloc
>  - some Xen fixes and improvements:
>    - unify PAE/non-PAE pagetable handling
>    - implement sysenter where applicable

thanks Jeremy, i've queued them all up and the current x86/latest branch 
should have them. They looked robust so far in my testing.

	Ingo
