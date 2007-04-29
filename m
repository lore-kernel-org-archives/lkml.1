Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbXD2AFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbXD2AFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXD2AFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:05:32 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37667 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754450AbXD2AFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:05:31 -0400
Date: Sun, 29 Apr 2007 02:05:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429000542.GH3468@stusta.de>
References: <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org> <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com> <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 04:40:31PM -0700, Linus Torvalds wrote:
>...
> What's the difference between bugzilla and lkml.org? Both have search 
> buttons. Both archive the old stuff. Both can be pointed to.

Mailing lists don't track bugs.

The _only_ reason why I originally started regression lists was because 
several kernel developers were spreading the fairy tale "noone tests -rc 
kernels".

This was only possible because so many bug reports to linux-kernel never 
get any reply, and are therefore lost.

After I started the regression lists, it suddenly turned out how many 
people test -rc kernels, and that even with regression lists at least 
weekly, it still often took weeks ontil some developer even started 
debugging a regression.

So what's the difference between bugzilla and lkml.org?
In Bugzilla we are able to see how bad our bug handling is...

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

