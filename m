Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXDYPbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXDYPbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXDYPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:31:32 -0400
Received: from xenotime.net ([66.160.160.81]:45394 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753984AbXDYPbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:31:31 -0400
Date: Wed, 25 Apr 2007 08:35:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       trivial@kernel.org
Subject: Re: [PATCH] Fix chapter reference in CodingStyle
Message-Id: <20070425083506.2a58c512.rdunlap@xenotime.net>
In-Reply-To: <200704231210.23105.jesper.juhl@gmail.com>
References: <200704231210.23105.jesper.juhl@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 12:10:22 +0200 Jesper Juhl wrote:

> Greetings,
> 
> commit 226a6b84aaaf1fac7a5d41cf4e7387fd9ba895d5 renumbered Chapter 11 in 
> Documentation/CodingStyle to Chapter 12, but it didn't update the reference 
> to that chapter further down in the file. This patch corrects the chapter 
> reference.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

> --- 
> 
>  Documentation/CodingStyle |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 9069189..899777f 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -625,7 +625,7 @@ language.
>  
>  There appears to be a common misperception that gcc has a magic "make me
>  faster" speedup option called "inline". While the use of inlines can be
> -appropriate (for example as a means of replacing macros, see Chapter 11), it
> +appropriate (for example as a means of replacing macros, see Chapter 12), it
>  very often is not. Abundant use of the inline keyword leads to a much bigger
>  kernel, which in turn slows the system as a whole down, due to a bigger
>  icache footprint for the CPU and simply because there is less memory
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
