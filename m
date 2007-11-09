Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXKIQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXKIQT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXKIQTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:19:49 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47970 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbXKIQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:19:49 -0500
Date: Fri, 9 Nov 2007 17:19:24 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Patch tags [was writeout stalls in current -git]
Message-ID: <20071109161924.GH26163@stusta.de>
References: <20071106232651.GP26163@stusta.de> <7192.1194624647@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7192.1194624647@lwn.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 09:10:47AM -0700, Jonathan Corbet wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > What's missing is a definition which of them are formal tags that must 
> > be explicitely given (look at point 13 in SubmittingPatches).
> > 
> > Signed-off-by: and Reviewed-by: are the formal tags someone must have 
> > explicitely given and that correspond to some statement.
> > 
> > OTOH, I can translate a "sounds fine" or "works for me" someone else 
> > gave me into an Acked-by: resp. Tested-by: tag.
> 
> The discussion of the Cc: tag says:
> 
> 	This is the only tag which might be added without an explicit
> 	action by the person it names.
> 
> I think that addresses your comment, no?  Certainly I wouldn't feel that
> I could add any of the other tags to a patch I posted - that's the job
> of the person named there.  

Acked-by: and Tested-by: do require explicit actions by the person they 
name, but they are not required to explicitely give this tag.

If a user said "the patch works for me" I would consider it overly 
bureaucratic to ask the user for a formal tag.

> jon

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

