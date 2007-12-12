Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXLLU2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXLLU2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXLLU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:27:43 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:42728 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967AbXLLU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:27:41 -0500
Date: Wed, 12 Dec 2007 15:27:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>, Daniel Walker <dwalker@mvista.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH RT] Revert Softdisable for simple irqs.
In-Reply-To: <3efb10970712121205s7fcda39dt7cfa154c53f3eecb@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0712121526380.22462@gandalf.stny.rr.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com> 
 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com> 
 <1196176294.13982.58.camel@localhost.localdomain>  <1196177122.23808.7.camel@imap.mvista.com>
  <1196178834.23808.11.camel@imap.mvista.com>  <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
 <3efb10970712121205s7fcda39dt7cfa154c53f3eecb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Dec 2007, Remy Bohmer wrote:
> Also:
> Acked-by: Remy Bohmer <linux@bohmer.net>
>
> Thanks for the effort also, I still had it on my todo list, but that
> is needed anymore...

No problem. Could you also ACK the one I sent for mainline.

Thanks,

-- Steve

