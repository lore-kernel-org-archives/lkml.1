Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbXG1Prg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbXG1Prg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXG1Pra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:47:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47302 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378AbXG1Pr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:47:29 -0400
Date: Sat, 28 Jul 2007 17:47:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: RFC: UML: remove MODE_TT?
Message-ID: <20070728154705.GB30976@stusta.de>
References: <20061212233533.GB28443@stusta.de> <20061213041837.GA8825@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20061213041837.GA8825@ccure.user-mode-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 12, 2006 at 11:18:37PM -0500, Jeff Dike wrote:
> On Wed, Dec 13, 2006 at 12:35:33AM +0100, Adrian Bunk wrote:
> > MODE_TT is both marked as deprecated and marked as BROKEN.
> > 
> > Would a patch to remove MODE_TT, always enable MODE_SKAS, and doing all 
> > possible cleanups after this be accepted?
> 
> Thanks, but not yet.
> 
> I've got that queued up in my tree now, waiting for SMP to work.  SMP is 
> the one remaining justification for TT mode, so I'll get that in, then remove
> MODE_TT and do the associated cleanups.

MODE_TT is still marked as broken and still not compiling...

Will anyone fix it or can it finally be removed?

> 				Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

