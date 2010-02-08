Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0BHHPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:15:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0BHHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:15:21 -0500
Date: Mon, 8 Feb 2010 08:15:15 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Message-ID: <20100208071515.GA6473@fancy-poultry.org>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
 <445R0ey9hAI.A.tNB.XozbLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <445R0ey9hAI.A.tNB.XozbLB@chimera>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100131 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX19YkDQTR3DDHX+C7B5T1fd37qG0/XkYgYN3u3P
 pDsKHpBxCviYM5SPvT/NQGJBj5JCTN8FqJV6Km3M69aGtR9Wuc
 ninET/5g6u/ozrUFasEdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.02.2010, Rafael J. Wysocki wrote: 

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15196
> Subject		: kmem_cache_create: duplicate cache ccid2_h
> Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> Date		: 2010-01-30 18:33 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=126487640324942&w=4
> Handled-By	: Xiaotian Feng <xtfeng@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/77601/

Yes, it's still present in -rc7.


