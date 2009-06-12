Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbZFLJBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbZFLJBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZFLJAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:00:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZFLJAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:00:52 -0400
Date: Fri, 12 Jun 2009 11:00:54 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Markus Heidelberg <markus.heidelberg@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: remove the trivial patch monkey's name from
 SubmittingPatches
In-Reply-To: <1244761355-1099-1-git-send-email-markus.heidelberg@web.de>
Message-ID: <alpine.LNX.2.00.0906121100380.7457@wotan.suse.de>
References: <1244761355-1099-1-git-send-email-markus.heidelberg@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Markus Heidelberg wrote:

> It is outdated here and can be found in the MAINTAINERS file. Also
> remove the URL of the previous maintainer, similar content can be found
> in the SubmittingPatches file.
> 
> Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
> ---
>  Documentation/SubmittingPatches |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index f309d3c..9534311 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -183,8 +183,9 @@ Even if the maintainer did not respond in step #4, make sure to ALWAYS
>  copy the maintainer when you change their code.
>  
>  For small patches you may want to CC the Trivial Patch Monkey
> -trivial@kernel.org managed by Jesper Juhl; which collects "trivial"
> -patches. Trivial patches must qualify for one of the following rules:
> +trivial@kernel.org which collects "trivial" patches. Have a look
> +into the MAINTAINERS file for its current manager.
> +Trivial patches must qualify for one of the following rules:
>   Spelling fixes in documentation
>   Spelling fixes which could break grep(1)
>   Warning fixes (cluttering with useless warnings is bad)
> @@ -196,7 +197,6 @@ patches. Trivial patches must qualify for one of the following rules:
>   since people copy, as long as it's trivial)
>   Any fix by the author/maintainer of the file (ie. patch monkey
>   in re-transmission mode)
> -URL: <http://www.kernel.org/pub/linux/kernel/people/juhl/trivial/>

Applied, thanks Markus.

-- 
Jiri Kosina
SUSE Labs

