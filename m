Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYLBNMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYLBNMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYLBNMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:12:05 -0500
Received: from ports.donpac.ru ([80.254.111.81]:54151 "EHLO ports.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYLBNME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:12:04 -0500
Date: Tue, 2 Dec 2008 16:11:58 +0300
To: Alejandro Riveira Fern??ndez <ariveira@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202131158.GA15186@ports.donpac.ru>
Mail-Followup-To: Alejandro Riveira Fern??ndez <ariveira@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202131442.42e7df48@varda>
X-Uname: Linux 2.6.18-4-powerpc64 ppc64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: pazke <pazke@ports.donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 337, 12 02, 2008 at 01:14:42PM +0100, Alejandro Riveira Fern??ndez wrote:
> El Mon, 1 Dec 2008 20:11:55 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> escribi??:
> 
> > 
> > I was gone for a week, and it wasn't quite as quiet as I was hoping for, 
> > but there's a new -rc out there now with the merges of the fallout.
> > 
> > Almost all of it is various driver fixes, at least if you ignore the 
> > (bulky) powerpc defconfig updates. The bulk being ACPI, DRM, input and 
> > V4L, but with a smattering of usb, networking, infiniband and firewire.
> > 
> > Oh, and a number of section warning fixes.
> > 
> > The shortlog is about as informative as it gets - it's all about a lot of 
> > small details.
> > 
> > 		Linus
> > 
> 
>  Just tried it on my Ubuntu 8.10 install.
>  Booted fine and the distro got to its safe graphics mode because i'm
>  evil and use the nvidia kernel module. i switch to VT1 and the fun
>  begins something weird happens with the terminal...
>  I can not see the login: not the password: promts 
>  I log in blindly
>  When i type a command nothing appears on screen i have to hit enter twice
>  one make the command appear the second actually executes
>  After that i have to hit enter once more to get the shell promt again
>  Also I couldn't use sudo the password promt did not get my password
>  
>  All of this happens without the nvidia module loaded (not even compiled) 

Realy ?

> [  101.744347] nvidia: module license 'NVIDIA' taints kernel.
> [  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
> [  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
> [  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06  Sat Nov  8 17:50:38 PST 2008
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Where do these messages come from then ?
