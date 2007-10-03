Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXJCWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXJCWmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbXJCWmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:42:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49018 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXJCWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:42:07 -0400
Date: Wed, 3 Oct 2007 14:38:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rob@landley.net,
       johnpol@2ka.mipt.ru
Subject: Re: + add-documentation-w1w1-masters-00-index.patch added to -mm
 tree
Message-Id: <20071003143849.46c7f157.randy.dunlap@oracle.com>
In-Reply-To: <200710032117.l93LHXI0009109@imap1.linux-foundation.org>
References: <200710032117.l93LHXI0009109@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 14:17:33 -0700 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Add Documentation/{w1,w1/masters}/00-INDEX
> has been added to the -mm tree.  Its filename is
>      add-documentation-w1w1-masters-00-index.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: Add Documentation/{w1,w1/masters}/00-INDEX
> From: Rob Landley <rob@landley.net>
> 
> Two 00-INDEX files under Documentation/w1
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> 
> diff -puN /dev/null Documentation/w1/00-INDEX
> --- /dev/null
> +++ a/Documentation/w1/00-INDEX
> @@ -0,0 +1,8 @@
> +00-INDEX
> +	- This file
> +masters/
> +	- Individual chips providing 1-wire busses.
> +w1.generic
> +	- The 1-wire (w1) bus
> +w1.netlink
> +	- Userspace communication protocol over connector [1].
> diff -puN /dev/null Documentation/w1/masters/00-INDEX
> --- /dev/null
> +++ a/Documentation/w1/masters/00-INDEX
> @@ -0,0 +1,6 @@
> +00-INDEX
> +	- This file
> +ds2482
> +	- The Maixm/Dallas Semiconductor DS2482 provides 1-wire busses.
> +ds2490
> +	- The Maixm/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.

              Maxim (2 times)

Was this patch posted to a mailing list?  if so, which one?
I didn't see it.
And if not, please post all patches for review.


---
~Randy
