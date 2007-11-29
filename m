Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbXK2Vhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbXK2Vhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763614AbXK2VhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:37:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763749AbXK2VhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:37:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 09/11] x86 ia32 ptrace arch merge
In-Reply-To: Alexey Dobriyan's message of  Thursday, 29 November 2007 23:58:52 +0300 <20071129205852.GA1726@martell.zuzino.mipt.ru>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129120041.8621A26F989@magilla.localdomain>
	<20071129205852.GA1726@martell.zuzino.mipt.ru>
X-Windows: putting new limits on productivity.
Message-Id: <20071129213705.35E2826F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 13:37:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 29, 2007 at 04:00:41AM -0800, Roland McGrath wrote:
> > This moves the sys32_ptrace code into arch/x86/kernel/ptrace.c,
> > verbatim except for a few hard-coded sizes replaced with sizeof.
    ^^^^^^^^
>[...]

I just moved this code, I didn't change it.  So let's leave style (or
other) problems with the existing code for a next round and not hold
up the moving/merging because of them.


Thanks,
Roland
