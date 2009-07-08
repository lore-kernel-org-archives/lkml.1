Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZGHQTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZGHQTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZGHQTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:19:47 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26481 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZGHQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:19:46 -0400
Date: Wed, 8 Jul 2009 09:17:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Miguel Ojeda Sandonis <maxextreme@gmail.com>,
       Paulo Marques <pmarques@grupopie.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/44] includecheck fix: Documentation,
 cfag12864b-example.c
Message-Id: <20090708091724.c78e8253.randy.dunlap@oracle.com>
In-Reply-To: <1247065369.4382.54.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	<1247065369.4382.54.camel@ht.satnam>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A54C694.0274:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jul 2009 20:32:49 +0530 Jaswinder Singh Rajput wrote:

> 
> fix the following 'make includecheck' warning:
> 
>   Documentation/auxdisplay/cfag12864b-example.c: string.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  Documentation/auxdisplay/cfag12864b-example.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/auxdisplay/cfag12864b-example.c b/Documentation/auxdisplay/cfag12864b-example.c
> index 2caeea5..156bcaa 100644
> --- a/Documentation/auxdisplay/cfag12864b-example.c
> +++ b/Documentation/auxdisplay/cfag12864b-example.c
> @@ -194,7 +194,6 @@ void cfag12864b_blit(void)
>   */
>  
>  #include <stdio.h>
> -#include <string.h>
>  
>  #define EXAMPLES	6
>  
> -- 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
