Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZDPU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZDPU0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZDPUZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:25:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17305 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZDPUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:25:46 -0400
Date: Thu, 16 Apr 2009 22:25:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Documentation: Add "how to write a good patch summary"
 to SubmittingPatches
In-Reply-To: <1239882285-4994-1-git-send-email-tytso@mit.edu>
Message-ID: <alpine.LNX.2.00.0904162223280.32544@swampdragon.chaosbits.net>
References: <1239882285-4994-1-git-send-email-tytso@mit.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009, Theodore Ts'o wrote:

> Unfortunately many patch submissions are arriving with painfully poor
> patch descriptions.   As a result of the discussion on LKML:
> 
>       http://lkml.org/lkml/2009/4/15/296
> 
> explain how to submit a better patch description, in the (perhaps
> vain) hope that maintainers won't end up having to rewrite the git
> commit logs as often as they do today.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 

Read through your diff. Looks good to me - nice additions.

Feel free to add
 Acked-by: Jesper Juhl <jj@chaosbits.net>
or
 Reviewed-by: Jesper Juhl <jj@chaosbits.net>
if you like...

Don't really know what's most appropriate here, but I like the patch.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

