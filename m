Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbYBLJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbYBLJfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYBLJfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:35:23 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51378 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbYBLJfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:35:22 -0500
Date: Tue, 12 Feb 2008 10:35:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v9
Message-ID: <20080212093527.GA31331@uranus.ravnborg.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212100327.GA30873@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +/**
> > + *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
> 
> All the kerneldoc comments are useless if you don't add the file
> to Documentation/DocBook/*.tmpl
1) The content is valid no matter the formatting
2) It is a well known format
3) And it is widely used

Using a wellknown format does not require it to be postprocessed.
It is by far better than "one-format-for-each-developer".

	Sam
