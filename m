Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYHXTD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYHXTD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYHXTDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:03:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYHXTDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:03:50 -0400
Date: Sun, 24 Aug 2008 12:03:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
Message-ID: <alpine.LFD.1.10.0808241201090.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11356
> Subject		: Linux 2.6.27-rc3 - build failure: undefined reference to `.lockdep_count_forward_deps'
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-08-16 19:11 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121891396320127&w=4

Hmm. Wasn't this already confirmed to be fixed by commit
df60a8441866153d691ae69b77934904c2de5e0d? 

At least Adrian sent out an email saying "Confirmed, bug closed.", but 
bugzilla seems to disagree and still show it as open.

		Linus
