Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXHPLpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXHPLpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXHPLpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:45:12 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:38057 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXHPLpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:45:11 -0400
Message-ID: <46C43818.4050506@aitel.hist.no>
Date: Thu, 16 Aug 2007 13:42:16 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <174219.56922.qm@web52501.mail.re2.yahoo.com>
In-Reply-To: <174219.56922.qm@web52501.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> Kyle, What I'm suggesting is scrapping all existing
> concepts and replacing them with something entirely
> new. Posix, Unix, SELinux go away except for an
> emulation layer for backwards compatibility. What I'm
> suggesting is to start over and do it right. 
>   
If you want to get any support for "starting over",
then  you need to:
1. Point out some serious problem with the existing stuff,
   otherwise why _bother_ start over
2. Come up with a truly better idea (demonstrably better)
    that isn't full of so obvious flaws that a seasoned kernel
    developer can shoot it down in 5 minutes.

Trying to be a visionary with a "great idea" that you are
prepared to let others implement just don't work on
this list.  If you want to go that route, you
start a company, hire programmers, tell them to
implement your vision. If your idea is good then
your company succeeds.

If you want to be an open-source visionary, you have to
do the initial work yourself until you attract other interested people.

> One of the problems with the Unix/Linux world is that
> your minds are locked into this one model. In order to
> do it right it requires the mental discipline to break
> out of that.
>   
Or perhaps unix have the best model already? ;-)
If you want a big break with the existing unix models, then
perhaps a entirely new project is in order, rather than
trying to change linux. Linux is after all, in use by millions
who are satisfied with the linux filesystem model already.

Now, linux is open-source, so you can of course use it as a
starting point for your different system.  Then you can compete
with "standard linux" - see who attracts most developers and
most users in the long run.

Helge Hafting
