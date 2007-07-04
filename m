Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbXGDGfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbXGDGfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXGDGfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:35:40 -0400
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:37106 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbXGDGfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:35:40 -0400
Date: Wed, 04 Jul 2007 02:35:39 -0400
From: Darren <kernel@da4.org>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-reply-to: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
To: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org
Message-id: <468B3FBB.9050006@da4.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 8BIT
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K³oczko wrote:
>
> Few dayas ago OSS source code was oppened uder CDDL for Solaris and 
> GLPv2 for Linux:
>
> http://www.opensound.com/press/2007/oss-gpl-cddl.txt
>
> So this source without problems code can be integragrated in Linus 
> tree and after this Linux can provide much better soud supoport than 
> with current ALSA.
>
> Any plans for doing this ?
>
> kloczek

I know this may sound kind of stupid, but how about not deprecating 
either, and fully supporting both sound systems? Maybe we can get them 
to work together, and the distro or user can choose whether they would 
like to use alsa or oss for that particular card (or have the distro 
choose the sound drivers that are best supported for that particular 
card). As it is now, most apps already support oss and alsa.
