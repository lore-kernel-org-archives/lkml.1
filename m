Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbXK2XDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbXK2XDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbXK2XDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:03:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762737AbXK2XDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:03:06 -0500
Message-ID: <474F44F6.2060704@redhat.com>
Date: Thu, 29 Nov 2007 18:02:14 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jan.kratochvil@redhat.com
Subject: Re: [PATCH x86/mm 01/11] x86-32 thread_struct.debugreg
References: <20071129115711.9FC8526F8E7@magilla.localdomain>	<20071129122324.GA11414@elte.hu> <20071129215055.3A79D26F8E7@magilla.localdomain>
In-Reply-To: <20071129215055.3A79D26F8E7@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2007 04:50 PM, Roland McGrath wrote:
> Jan Kratochvil has helped me a great deal with ptrace testing lately.
> We have started to collect a small regression test suite, see
> http://sourceware.org/systemtap/wiki/utrace/tests for pointers.  That
> has tests for individual problems that have come up, and not anything
> exhaustive for testing all ptrace functionality.

You could contribute them to LTP?
