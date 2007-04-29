Return-Path: <linux-kernel-owner+w=401wt.eu-S1161498AbXD2WJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161498AbXD2WJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161509AbXD2WJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:09:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32877 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161498AbXD2WJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:09:17 -0400
Date: Mon, 30 Apr 2007 00:09:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Markus Rechberger <mrechberger@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429220928.GW3468@stusta.de>
References: <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org> <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com> <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org> <20070429000542.GH3468@stusta.de> <20070429212756.GA14857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070429212756.GA14857@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 05:27:56PM -0400, Dave Jones wrote:
> On Sun, Apr 29, 2007 at 02:05:42AM +0200, Adrian Bunk wrote:
>  > On Sat, Apr 28, 2007 at 04:40:31PM -0700, Linus Torvalds wrote:
>  > >...
>  > > What's the difference between bugzilla and lkml.org? Both have search 
>  > > buttons. Both archive the old stuff. Both can be pointed to.
>  > 
>  > Mailing lists don't track bugs.
> 
> There's no reason they can't.  Store them in folders 'fixed' 'pending'
> 'notabug' etc. Move mails between them when states change.
> reply-to them when necessary. Bounce them. Add people to Ccs. etc. etc.
> 
> The only remaining piece of the puzzle is "how does everyone see the
> states of the various pools", which could be solved in a number of
> ways, daily uploads to a place on kernel org for eg.
> 
> Hell, you could store them in a git tree if it came to it.
> That would also solve the problem for those with an aversion
> to web browsers to see bugs :-)

That would be an implementation of a git based bug tracker.  :-)

> 	Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

