Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZDGL0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZDGL0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZDGL0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:26:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZDGL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:26:21 -0400
Date: Tue, 7 Apr 2009 12:58:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Static/Runtime CPU/IO bound scheduling polices based on CPU(s) to support complete spectrum of tasks
Message-ID: <20090407105835.GP17934@one.firstfloor.org>
References: <1239099931.4773.25.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239099931.4773.25.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:55:31PM +0530, Jaswinder Singh Rajput wrote:
> I am planning to prepare the followings:

This seems all quite vague. Perhaps it would be good if you started
with a clear definition what problem you're trying to solve.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
