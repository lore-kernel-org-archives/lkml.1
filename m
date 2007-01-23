Return-Path: <linux-kernel-owner+w=401wt.eu-S965598AbXAWXfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598AbXAWXfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965599AbXAWXfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:35:47 -0500
Received: from main.gmane.org ([80.91.229.2]:50583 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965598AbXAWXfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:35:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: identifying CONFIG variable typoes in the source tree
Date: Tue, 23 Jan 2007 23:35:31 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerd7e8.e7s.olecom@flower.upol.cz>
References: <Pine.LNX.4.64.0701231559090.3014@CPE00045a9c397f-CM001225dbafb6>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-01-23, Robert P. J. Day wrote:
[]
>   what it does is scan the entire tree for lines of the form
>
> ...if... CONFIG_whatever...
>
> collects all of those CONFIG variables and, one at a time, checks to
> see if that variable even exists in any Kconfig file in the tree so
> that it could possibly ever be set.  (i'm not guaranteeing that the
> script is perfect, but it does generate some interesting results.)
>
>   the first few lines of output:
>
> 53C700_BE_BUS
> 64_BIT
> 68328_SERIAL_UART2
> ...
>
[]
>   the script turns up 284 examples of this.

Next, this script must to learn how to search whom to send this info.
And if there's nobody, just to make list of known orphans ;).

> rday

____

