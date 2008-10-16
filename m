Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYJPSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYJPSpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYJPSpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:45:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYJPSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:45:16 -0400
Date: Thu, 16 Oct 2008 14:45:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       linuxppc-dev@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
In-Reply-To: <20081016183529.GB29739@yoda.jdub.homelinux.org>
Message-ID: <alpine.DEB.1.10.0810161444050.11042@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu> <20081016181452.GA29739@yoda.jdub.homelinux.org> <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com> <20081016183529.GB29739@yoda.jdub.homelinux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Oct 2008, Josh Boyer wrote:
> 
> Well, that's why I asked.  You sent 2 patches out over a month ago that
> don't appear to have shown up in any Linus or PowerPC tree.

Oh, the patches I sent on here, are not to solve this issue. It was 
actually solving issues in linux-tip itself.

I'm still looking into the cause for ftrace not to boot on PPC.

-- Steve
