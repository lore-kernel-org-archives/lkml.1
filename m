Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbXJ2RgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbXJ2RgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbXJ2RgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:36:14 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:53066 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbXJ2RgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:36:13 -0400
Message-ID: <472619FE.80309@debian.org>
Date: Mon, 29 Oct 2007 18:35:58 +0100
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: last git: BUG: unable to handle kernel paging request at virtual
 address 92184900
References: <471E45B4.9050504@debian.org> <20071029011148.76ae8dd4.akpm@linux-foundation.org>
In-Reply-To: <20071029011148.76ae8dd4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 23 Oct 2007 21:04:20 +0200 Giacomo Catenazzi <cate@debian.org> wrote:
> 
>> Oct 23 20:20:05 catee kernel: BUG: unable to handle kernel paging request at virtual address 92184900
> 
> Is this still happening in the latest Linus tree?
> 
> If so, please send some more oops traces so we can see if it's always happening
> in the same place.

No, since few days I didn't have kernel crashes, so I think the
bug was solved.

ciao
	cate
