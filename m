Return-Path: <linux-kernel-owner+w=401wt.eu-S934410AbXGUAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbXGUAQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbXGUAQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:16:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:43826 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbXGUAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BKn/+U4d/jnv5/VfOAj6CefNGOsWMwlc6U4uc28gU/dy8S2+TsVet18TVDFQbNa6bwxkKhdwRUaWUJZh0MdK1pgNcStPF0pyLROnjmHFmbx89aTvz+TXVvhVIr/udrkqTgIYzKyMYDlEjPkKcyHesKwlgDxBuevcZz5BI2M5x5I=
Message-ID: <6bffcb0e0707201716p7ed33e26p9156bebc4207b550@mail.gmail.com>
Date: Sat, 21 Jul 2007 02:16:34 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>,
       "Andi Kleen" <ak@suse.de>, "Arjan van de Ven" <arjan@infradead.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20070721000309.GA24829@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184970779.4012.38.camel@chaos>
	 <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
	 <20070721000309.GA24829@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > >We are pleased to announce a project we've been working on for some
> > >time: the unified x86 architecture tree, or "arch/x86" - and we'd
> > >like to solicit feedback about it.
> > >
> > >What is this about?
> > [..]
> > >As usual, comments and suggestions are welcome!
> >
> > I really like this idea - code duplication is a bad thing.
> >
> > BTW. I don't see any regression here :)
>
> cool - could you tell us a bit more about on what type of box you tried
> it,

it is an old P4 (i386)

> and how wide and versatile the .config is?

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-git15/config

>
>         Ingo
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
