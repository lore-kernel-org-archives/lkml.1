Return-Path: <linux-kernel-owner+w=401wt.eu-S937317AbXGTXzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937317AbXGTXzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXGTXz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:55:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:49821 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXGTXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nmpTGzUxfYZ7D17Z8K9dCEHV97WUdho6rBLJs1J2UX/iBH/ENR1XhbArLrTU9sSd0w23zxNWjYSu4/JTC6YwPhFEDTxxhsTMkATjTaWLj2YlVgW7volP4rgee27avxkbw33kTAniJZSSJbAqHM9esvr20pFJwHXrofhwaDhGOSo=
Message-ID: <6bffcb0e0707201655q664202e6v29b4e678de1b0d80@mail.gmail.com>
Date: Sat, 21 Jul 2007 01:55:22 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Cc: LKML <linux-kernel@vger.kernel.org>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <1184970779.4012.38.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184970779.4012.38.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/07/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are pleased to announce a project we've been working on for some
> time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> to solicit feedback about it.
>
> What is this about?
[..]
> As usual, comments and suggestions are welcome!

I really like this idea - code duplication is a bad thing.

BTW. I don't see any regression here :)

>
>         Thomas, Ingo

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
