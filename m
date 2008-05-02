Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbYEBHCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbYEBHCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbYEBHBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:01:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57421 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbYEBHBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:01:52 -0400
Subject: Re: Slow DOWN, please!!!
From: Kasper Sandberg <lkml@metanurb.dk>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f9d2a5e10805011954l12b54802t63b9ce0957b6087b@mail.gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	 <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
	 <4818C0BF.5020002@davidnewall.com>
	 <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org>
	 <4818C571.8040609@davidnewall.com>
	 <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
	 <481947AF.4090101@davidnewall.com> <1209655700.27499.28.camel@localhost>
	 <loom.20080501T174627-71@post.gmane.org>
	 <1209692875.16523.10.camel@localhost>
	 <f9d2a5e10805011954l12b54802t63b9ce0957b6087b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 09:01:47 +0200
Message-Id: <1209711707.16523.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 19:54 -0700, Russ Dill wrote:
> >  i can also say that i have noticed this on my own workstation, however
> >  thats not really an as valid case, as i have also upgraded userspace and
> >  such over time, but it used to be that my box wouldnt use more than
> >  ~100mb to boot into X with kde open, and about ~300mb at browsing/mail
> >  and such, but these days my workstation easily uses 1.5gb of ram for no
> >  apparent reason..
> >
> >  something certainly is fishy around here, these days people just tend to
> >  fix it by throwing 10 times more ram in than should really be necessary,
> >  which i guess, is because the ram prices has dropped 10 times
> >
> 
> So you aren't really contributing anything to the discussion. It could
> be userspace, it could be different types of pages you are visiting,
> it could be the kernel, you haven't really measured what is taking up
> the memory. And of course, its all because developers are lazy. Thanks
> for the input.

I think you didnt read read the first part of my message..

And as i said, on my workstation i have no idea exactly WHAT has changed
to cause it.. i just came with some information..

And of course, its all because the person writing the email forgets to
include key details such as "however, thats not really an as valid
case...". Thanks for the input..

