Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXEEGhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXEEGhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 02:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXEEGhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 02:37:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:47460 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbXEEGhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 02:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=niRozXvbDQiVvVcPl0UVFBMIETA5UTOQT/cKhRvq6gOb/b0jgYAbQJL3zUh/IRQFC3mz8wzBoxqyHhM3gpUAhWFPuho8rCg27qn3dIoeO0BOmx7jVFHm99qkzQW3QCamg53tueGyOUXx6iCNpj3EhN5vymO5JdmfcE1WFdCpwNU=
Message-ID: <99e4df080705042337y7a79b321j3e5e23d83aa15b03@mail.gmail.com>
Date: Sat, 5 May 2007 14:37:39 +0800
From: "la deng" <ladeng.mimi@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: c 's OOP in VFS vs c++'s OOP
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0705041613580.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com>
	 <20070504101129.GA5482@localhost.localdomain>
	 <99e4df080705040400p66819117sec7f7d88d3794871@mail.gmail.com>
	 <Pine.LNX.4.61.0705041339220.18504@yvahk01.tjqt.qr>
	 <20070504123047.GA2255@localhost.localdomain>
	 <99e4df080705040653l38daa61aw3883b7c55c8e9de7@mail.gmail.com>
	 <Pine.LNX.4.61.0705041613580.18504@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On May 4 2007 21:53, la deng wrote:
> >>
> >> C gives you the power to control nearly everything. You can, of course,
> >> control the registers via inserting assembly code. That's not the fault of
> >> C.
> > I think you don't understand me correctly
> >
> > I know c can inline assmebly to control registers
> >
> > but,this control not the globe Analysis of control register like
> > internal of c++ compiler or lisp 's compiler language,c can't
>
> Using __asm__ in C++ is the same thing as in C. If you want to
> make GCC aware of registers you could use
>
>
>      register int *p1 asm ("r0") = ...;
>
> See chapter "5.37 Variables in Specified Registers" in `info gcc`.
>
>
> Jan
> --
>
hmm,thanks

I found gcc has some extensions can help this

very thanks
