Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbXKIQKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbXKIQKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbXKIQKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:10:48 -0500
Received: from vena.lwn.net ([206.168.112.25]:34167 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbXKIQKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:10:48 -0500
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Patch tags [was writeout stalls in current -git] 
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 07 Nov 2007 00:26:51 +0100."
             <20071106232651.GP26163@stusta.de> 
Date: Fri, 09 Nov 2007 09:10:47 -0700
Message-ID: <7192.1194624647@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> What's missing is a definition which of them are formal tags that must 
> be explicitely given (look at point 13 in SubmittingPatches).
> 
> Signed-off-by: and Reviewed-by: are the formal tags someone must have 
> explicitely given and that correspond to some statement.
> 
> OTOH, I can translate a "sounds fine" or "works for me" someone else 
> gave me into an Acked-by: resp. Tested-by: tag.

The discussion of the Cc: tag says:

	This is the only tag which might be added without an explicit
	action by the person it names.

I think that addresses your comment, no?  Certainly I wouldn't feel that
I could add any of the other tags to a patch I posted - that's the job
of the person named there.  

jon
