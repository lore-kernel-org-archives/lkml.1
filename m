Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbZLMRaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbZLMRaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZLMRaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:30:00 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:42077 "HELO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750994AbZLMR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:29:59 -0500
Date: Sun, 13 Dec 2009 18:28:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Nir Tzachar <nir.tzachar@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: nconfig v7
Message-ID: <20091213172855.GA11741@merkur.ravnborg.org>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr> <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com> <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr> <20091213115546.GA10592@merkur.ravnborg.org> <alpine.LSU.2.01.0912131524250.6621@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.0912131524250.6621@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 03:25:14PM +0100, Jan Engelhardt wrote:
> 
> On Sunday 2009-12-13 12:55, Sam Ravnborg wrote:
> >
> >> >Thanks for catching this. It is a by-product of the code for
> >> >presenting everything inside a single menu. Easily fixed in the next
> >> >version. By the way, is anyone using this option at all? It would much
> >> >simplify the code if I did not have to support the one giant menu
> >> >option.
> >> 
> >> Well nconfig is the first to provide that option. (Note: I don't use 
> >> gconfig or xconfig, so I cannot tell if they have something like that.)
> >> So to see whether there is use, you would have to wait a number of 
> >> kernel releases that have nconfig integrated.
> >
> >We already have:
> >Optional personality available                                        
> >  . ------------------------------                                     
> >  . If you prefer to have all of the kernel options listed in a single  
> >  . menu, rather than the default multimenu hierarchy, run the menuconfig
> >  . with MENUCONFIG_MODE environment variable set to single_menu. Example:
> >  .                                                                   
> >  . make MENUCONFIG_MODE=single_menu menuconfig                        
> 
> I think the discussion went about "show hidden symbols" rather than
> "show everything in a single menu". Or at least that was my intention -
> sorry for any confusion.

I did not check what nconfig does exactly - I just assumed it was
the single_menu mode.
I know several people has requested the possibility to see all
ie. also hidden) symbols before.

	Sam
