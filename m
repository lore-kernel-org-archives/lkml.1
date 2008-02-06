Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbYBFVFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbYBFVFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbYBFVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:04:45 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52837 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759827AbYBFVEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:04:43 -0500
Date: Wed, 6 Feb 2008 23:04:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080206210452.GB7198@cs181133002.pp.htv.fi>
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au> <47A8F27F.3060504@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47A8F27F.3060504@nortel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 05:34:23PM -0600, Chris Friesen wrote:
> David Newall wrote:
>> That being said, a module can be written such that it only dynamically 
>> links with the kernel.  Ndiswrapper is an example of how this can be 
>> done: None of the drivers that work under ndiswrapper make any direct 
>> use of the kernel, not in any way, indeed a wrapper could be written 
>> for a different operating system.
>
> The issue is all about "derivative works" in copyright law.
>
> Ndiswrapper is in a good position because the closed-source drivers were  
> originally written for another OS so it's pretty well impossible to  
> argue that they are derived from linux.
>...

IANAL, but when looking at the "But when you distribute the same 
sections as part of a whole which is a work based on the Program, the 
distribution of the whole must be on the terms of this License" of the 
GPLv2 I would still consult a lawyer before e.g. selling a laptop with a 
closed-source driver loaded through ndiswrapper.

> Chris

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

