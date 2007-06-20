Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXFTTF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXFTTF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXFTTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:05:49 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:44325 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbXFTTFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HD5A2JWGu6ZnhtycBVj4k9110VUUsb4+fDq+xnibXMJ/IcbtmBtPYBKhvzXgdSkW/5+6mjI8O17GHClmaYR1rPC7CJdaS9NxscJYqwWsrQ7+WVGpO56fjLyg5kzzpu3I5B3bNgSAbriYu9oIO0PAkaD+91bYPPB/vHOf/tbmRwc=
Message-ID: <2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
Date: Wed, 20 Jun 2007 16:05:46 -0300
From: "Tomas Neme" <lacrymology@gmail.com>
To: "Michael Poole" <mdpoole@troilus.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <871wg6trnx.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	 <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	 <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	 <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
	 <871wg6trnx.fsf@graviton.dyn.troilus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's simple: they don't provide _complete_ source code.  They keep the
> source code for the part of their Linux kernel images that provides
> the functionality "runs on Tivo DVRs".  The GPL requires that

http://en.wikipedia.org/wiki/Tivoization does not agree that this is
the problem but rather "TiVo circumvented this goal by making their
products run programs only if the program's digital signature matches
those authorised by the manufacturer of the TiVo."

I'm downloading the sources now.. if they compile, then you're lying
to me, right? Moreover, if I compile them as is, and I can run them on
a TiVo (let's say upgrading the machine's kernel) then you're even
more so..

if this is all true, then I read GPLv2 and it tells me (clipping and ** mine):

0.  This License applies to any *program* or other work [...]. The
"Program", below, refers to any such program or work, and a "work
based on the Program" means either the Program or any derivative work
under copyright law: that is to say, *a work containing the Program or
a portion of it, either verbatim or with modifications* [...]

2.  You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications [...]

3.  You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:

    a) Accompany it with the complete corresponding machine-readable
source code, which must be distributed under the terms of Sections 1
and 2 above on a medium customarily used for software interchange;
[...]

The source code for a work means the preferred form of the work for
making modifications to it. For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable. However, as a
special exception, the source code distributed
*need*not*include*anything that is *normally*distributed (in *either*
source or *binary* form) with the major components (compiler, kernel,
and so on) of the operating system on which the executable runs,
unless that component itself accompanies the executable.

11.  BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR
OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY
KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME
THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

so, it very clearly says that the program and the modifications come
with NO WARRANTY of working, either expressed or implied, including
the warranty of fitness for a particular purpose (for example being
able to run in your TiVo box). Other than that the licence says you
can do whatever you want as long as you give out the source code.

Let me put it this way: if TiVo gave microsoft the keys to run in
TiVo, and Microsoft made a Windows Kernel for TiVo and it run, they
would not be needing to give you any source codes because the box
itself isn't GPL'ed and even if it was, there's no need to GLP stuff
that work on a system based on The Program (say Adobe finally ports
Photoshop into linux) but is not a modification or aggregation.
Whatever checks the kernel's key is outside of the kernel itself, and
probably not a modification of any GPL'ed software

plus, what I marked in point 3. says that they don't need to give you
anything that is normally distributed with the system the program runs
on. They don't need to give you the source or the design of their
hardware, or any embebbed software

so.. you're free to modify the kernel, try to figure out what TiVo
does for authentication and modify your binaries so they look what
TiVo wants them to.. add some garbage bits in the end, or something.

One more thing: even if the program they use to make their binaries
TiVo-key-check compliant was GPL'ed, they don't need to give it to
you, because the kernel does not use them. *IT* uses the compiled
kernel as input data (and produce signed kernel binaries as output),
not the other way around

Tomás

-- 
|_|0|_|
|_|_|0|
|0|0|0|
