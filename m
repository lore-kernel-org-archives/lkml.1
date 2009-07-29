Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbZG2Eya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbZG2Eya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 00:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZG2Eya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 00:54:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbZG2Ey3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 00:54:29 -0400
Date: Tue, 28 Jul 2009 21:54:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Gene Heskett <gene.heskett@verizon.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907282153300.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <20090729004639.71f0eabc@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <200907282250.46018.gene.heskett@verizon.net>
 <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Linus Torvalds wrote:
> 
> could you bisect the 13841 behavior?

Oh - and have you checked current -git? There's commit c56d300086, which 
may well have fixed some problems with openign a serial USB device.

		Linus
