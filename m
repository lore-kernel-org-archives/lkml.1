Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0CHTTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:19:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515Ab0CHTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:19:28 -0500
Date: Mon, 8 Mar 2010 11:18:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <20100308190857.400bde09@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <20100308190857.400bde09@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Alan Cox wrote:
>
> Quite untrue. I've actually *used* path based security systems (DEC10
> ACLs) and for almost every case its brain-dead.
> 
> Imagine a world where this happened

Alan, stop right there.

You're making the same silly and incorrect mistake that Al did.

Namely thinking that you have to have just one or the other.

When you say "your /etc/passwd example is a special case", you are 
admitting that there are two different cases, but then after that,  you 
still don't see the whole point I'm trying to make.

Let me try again:

  THERE ARE DIFFERENT CASES

That's the point. Just admit that, and then let the calm of "Ooh, there 
are different kinds of circumstances that may want different kinds of 
rules" permeate you.

My whole (and only) argument is against the "only one way is correct" 
mentality.

			Linus
