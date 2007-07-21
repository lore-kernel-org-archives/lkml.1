Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbXGUFmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbXGUFmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXGUFly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:41:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbXGUFlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:41:53 -0400
From: Andi Kleen <ak@suse.de>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Date: Sat, 21 Jul 2007 07:40:18 +0200
User-Agent: KMail/1.9.1
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
References: <1184970779.4012.38.camel@chaos> <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
In-Reply-To: <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210740.19227.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 01:55, Michal Piotrowski wrote:
> Hi,
>
> On 21/07/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > We are pleased to announce a project we've been working on for some
> > time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> > to solicit feedback about it.
> >
> > What is this about?
>
> [..]
>
> > As usual, comments and suggestions are welcome!
>
> I really like this idea - code duplication is a bad thing.

Did you actually look at the patch? It doesn't have a single line
less duplication than there was before. Everything that could
be easily shared was shared already. 

It's just new window dressing without any real advantages.

-Andi
