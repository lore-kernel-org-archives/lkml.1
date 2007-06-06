Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXFFPbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXFFPbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbXFFPb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:31:26 -0400
Received: from xenotime.net ([66.160.160.81]:35809 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751098AbXFFPbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:31:25 -0400
Date: Wed, 6 Jun 2007 08:31:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH][Trivial] SubmitChecklist update, fix spelling error
Message-Id: <20070606083145.0ed8b1ab.rdunlap@xenotime.net>
In-Reply-To: <200706061355.50161.jesper.juhl@gmail.com>
References: <200706061355.50161.jesper.juhl@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 13:55:48 +0200 Jesper Juhl wrote:

> 
> This trivial patch makes the following changes to Documentation/SubmitChecklist :
> 
>  - "sumbittal" is not a word, replace with "submission".
>  - Remove a blank line, two should be enough.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


>  Documentation/SubmitChecklist |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
> index 6ebffb5..19e7f65 100644
> --- a/Documentation/SubmitChecklist
> +++ b/Documentation/SubmitChecklist
> @@ -1,4 +1,4 @@
> -Linux Kernel patch sumbittal checklist
> +Linux Kernel patch submission checklist
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
>  Here are some basic things that developers should do if they want to see their
> @@ -9,7 +9,6 @@ Documentation/SubmittingPatches and elsewhere regarding submitting Linux
>  kernel patches.
>  
>  
> -
>  1: Builds cleanly with applicable or modified CONFIG options =y, =m, and
>     =n.  No gcc warnings/errors, no linker warnings/errors.
>  
> 
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
