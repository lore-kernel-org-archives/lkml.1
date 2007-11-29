Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbXK2WjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbXK2WjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761976AbXK2Wii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:38:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151AbXK2Wig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:38:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 11/11] x86 ptrace merge removals
In-Reply-To: Jeff Dike's message of  Thursday, 29 November 2007 09:04:12 -0500 <20071129140412.GA5412@c2.user-mode-linux.org>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129120057.5301426F8E7@magilla.localdomain>
	<20071129140412.GA5412@c2.user-mode-linux.org>
X-Windows: the first fully modular software disaster.
Message-Id: <20071129223803.C69A526F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 14:38:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 29, 2007 at 04:00:57AM -0800, Roland McGrath wrote:
> ...lots of ptrace merging...
> 
> Can you make sure that UML still runs when you're done with ptrace?

I'd be glad to, especially if you give me some advice on testing (.config
for um-i386 and um-x86_64, what do try that constitutes "UML still runs").
My patches are going into the x86/mm tree.  Right now (before these), UML
doesn't build for x86_64 or i386 from this tree to begin with.


Thanks,
Roland

