Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYJMFM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYJMFM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYJMFMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:12:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10913 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbYJMFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:12:20 -0400
Date: Sun, 12 Oct 2008 22:12:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jianjun Kong <kongjianjun@gmail.com>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATH] MAINTAINERS Move the sentence to right position
Message-Id: <20081012221212.9eaaa63f.randy.dunlap@oracle.com>
In-Reply-To: <20081013032041.GA7598@ubuntu>
References: <20081013032041.GA7598@ubuntu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 11:20:41 +0800 Jianjun Kong wrote:

> From: Jianjun Kong <kongjianjun@gmail.com>
> 
> There is a list of status follow "S:...", so "F:..." must be move to end.
> 
> Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks for catching that.

> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fb1aad7..97c6387 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -73,7 +73,6 @@ L: Mailing list that is relevant to this area
>  W: Web-page with status/info
>  T: SCM tree type and location.  Type is one of: git, hg, quilt.
>  S: Status, one of the following:
> -F: Applicable files and/or directories
>  
>  	Supported:	Someone is actually paid to look after this.
>  	Maintained:	Someone actually looks after it.
> @@ -84,6 +83,7 @@ F: Applicable files and/or directories
>  	Obsolete:	Old code. Something tagged obsolete generally means
>  			it has been replaced by a better system and you
>  			should be using that.
> +F: Applicable files and/or directories
>  
>  3C505 NETWORK DRIVER
>  P:	Philip Blundell


---
~Randy
