Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYHZTOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYHZTOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYHZTOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:14:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34629 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbYHZTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:14:44 -0400
Date: Tue, 26 Aug 2008 13:13:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Len Brown <len.brown@intel.com>, Robert Moore <robert.moore@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] acpi: semaphore removal
Message-ID: <20080826191335.GE23698@parisc-linux.org>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com> <1219777186-4787-2-git-send-email-dwalker@mvista.com> <1219777186-4787-3-git-send-email-dwalker@mvista.com> <1219777186-4787-4-git-send-email-dwalker@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219777186-4787-4-git-send-email-dwalker@mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 11:59:49AM -0700, Daniel Walker wrote:
> The semaphore usage in ACPI is more like completions. The ASL

Huh?  They are semaphores.  They're not 'more like completions' at all.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
