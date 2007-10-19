Return-Path: <linux-kernel-owner+w=401wt.eu-S936764AbXJSUka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936764AbXJSUka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbXJSUkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:40:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758739AbXJSUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:40:13 -0400
Date: Fri, 19 Oct 2007 13:40:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Gruenbacher <agruen@suse.de>
cc: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: LSM conversion to static interface
In-Reply-To: <200710192226.53233.agruen@suse.de>
Message-ID: <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Andreas Gruenbacher wrote:
> 
> Non-trivial modules (i.e., practically everything beyond capabilities) become 
> effective only after loading policy, anyway. If you can load policy, you can 
> as well first load a security module without making the system insecure.

I'd like to note that I asked people who were actually affected, and had 
examples of their real-world use to step forward and explain their use, 
and that I explicitly mentioned that this is something we can easily 
re-visit.

But I also note that you did no such thing, neither has anybody else.

The fact is, security people *are* insane. You just argue all the time, 
instead fo doing anything productive. So please don't include me in the Cc 
on your insane arguments - instead do something productive and I'm 
interested.

Ok? That was the whole point of LSM in the first place. I'm *not* 
interested in getting roped into your insane arguments. I'm interested in 
moving forward and having real examples of real use and code. Until then, 
this issue is closed. I thought I had made that clear already, but 
apparently not clear enough.

So I repeat: we can undo that commit, but I will damn well not care one 
whit about yet another pointless security model flamewar.

		Linus
