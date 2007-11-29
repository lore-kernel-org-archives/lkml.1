Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbXK2OHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbXK2OHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761662AbXK2OHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:07:31 -0500
Received: from [198.99.130.12] ([198.99.130.12]:47205 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761701AbXK2OHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:07:30 -0500
Date: Thu, 29 Nov 2007 09:04:12 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 11/11] x86 ptrace merge removals
Message-ID: <20071129140412.GA5412@c2.user-mode-linux.org>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120057.5301426F8E7@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129120057.5301426F8E7@magilla.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 04:00:57AM -0800, Roland McGrath wrote:
...lots of ptrace merging...

Can you make sure that UML still runs when you're done with ptrace?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
