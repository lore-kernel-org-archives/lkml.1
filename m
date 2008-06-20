Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYFTQHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYFTQHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYFTQGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:06:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53324 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYFTQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:06:54 -0400
Date: Fri, 20 Jun 2008 09:06:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] procfs-guide: drop pointless &nbsp; entities
Message-Id: <20080620090614.4befa3bb.randy.dunlap@oracle.com>
In-Reply-To: <1213977639-8229-1-git-send-email-vapier@gentoo.org>
References: <1213977639-8229-1-git-send-email-vapier@gentoo.org>
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

On Fri, 20 Jun 2008 12:00:39 -0400 Mike Frysinger wrote:

> Having trailing &nbsp; entities in a revision numer seems pretty pointless
> to me.  More so, it's causing me pains, so just drop them since no other
> guide is doing this.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  Documentation/DocBook/procfs-guide.tmpl |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/procfs-guide.tmpl b/Documentation/DocBook/procfs-guide.tmpl
> index 1fd6a1e..8a5dc6e 100644
> --- a/Documentation/DocBook/procfs-guide.tmpl
> +++ b/Documentation/DocBook/procfs-guide.tmpl
> @@ -29,12 +29,12 @@
>  
>      <revhistory>
>        <revision>
> -	<revnumber>1.0&nbsp;</revnumber>
> +	<revnumber>1.0</revnumber>
>  	<date>May 30, 2001</date>
>  	<revremark>Initial revision posted to linux-kernel</revremark>
>        </revision>
>        <revision>
> -	<revnumber>1.1&nbsp;</revnumber>
> +	<revnumber>1.1</revnumber>
>  	<date>June 3, 2001</date>
>  	<revremark>Revised after comments from linux-kernel</revremark>
>        </revision>
> -- 
> 1.5.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
