Return-Path: <linux-kernel-owner+w=401wt.eu-S1764825AbXIKVJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764825AbXIKVJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXIKVJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:09:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49201 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755174AbXIKVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:09:41 -0400
Date: Tue, 11 Sep 2007 23:09:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070911210948.GT3563@stusta.de>
References: <20070911201219.GA9674@uranus.ravnborg.org> <20070911203412.GS3563@stusta.de> <20070911210516.GA10160@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070911210516.GA10160@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 11:05:16PM +0200, Sam Ravnborg wrote:
> > 
> > As an example, visws.c is as much non-64bit as it is pre-i686.
> Bad example...
> visws is a visws specific file that should naver have allowed
> anywhere outside mach-visws.

Exactly, it's not about 64bit at all.

Similar, e.g. legacy.c is not about 32bit<->64bit.

> Any link-order issues should have been dealt with in other ways.
> 
> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

