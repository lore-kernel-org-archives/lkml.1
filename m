Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZIUJTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZIUJTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZIUJTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:19:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZIUJTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:19:40 -0400
Date: Mon, 21 Sep 2009 11:19:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] trivial: fix typos "enalbe" -> "enable"
In-Reply-To: <1253522362-22856-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0909211118340.17028@wotan.suse.de>
References: <1253522362-22856-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1221206043-1253524758=:17028"
Content-ID: <alpine.LNX.2.00.0909211119280.17028@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1221206043-1253524758=:17028
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0909211119281.17028@wotan.suse.de>

On Mon, 21 Sep 2009, Uwe Kleine-König wrote:

> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index aa99fd1..cfd4c91 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -22,6 +22,6 @@ config PAGE_POISONING
>  	   the patterns before alloc_pages(). This results in a large slowdown,
>  	   but helps to find certain types of memory corruptions.
>  
> -	   This option cannot enalbe with hibernation. Otherwise, it will get
> +	   This option cannot enable with hibernation. Otherwise, it will get
>  	   wrong messages for memory corruption because the free pages are not
>  	   saved to the suspend image.

This fix is not really correct -- the sentence doesn't have too much sense 
even after the typo fix.
Plus, it has been already fixed in a proper way, please see 
http://git.kernel.org/?p=linux/kernel/git/jikos/trivial.git;a=commitdiff;h=d5dd245f15b243b313df044741c0ba8065b0bc91

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-1221206043-1253524758=:17028--
