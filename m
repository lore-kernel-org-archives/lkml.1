Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZHZOBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZHZOBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZHZOBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:01:02 -0400
Received: from dd15922.kasserver.com ([85.13.137.18]:40758 "EHLO
	dd15922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZHZOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:01:01 -0400
From: Matthias Dahl <ml_kernel@mortal-soul.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #14011] Kernel paging request failed in kmem_cache_alloc
Date: Wed, 26 Aug 2009 16:01:05 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30.5; KDE/4.3.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.2bH.CtGlKB@chimera> <84144f020908252317j202aa459u27c40eed34debd6@mail.gmail.com>
In-Reply-To: <84144f020908252317j202aa459u27c40eed34debd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908261601.05734.ml_kernel@mortal-soul.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

> Can you reproduce the bug without the proprietary nvidia module that
> seems to be loaded?

I am sorry but I forgot to test that and right now I am not very keen on 
trying again since this is my primary machine and I had quite some fs 
corruption (ext4 on md raid5 -> no barriers) the last times. :-( But this also 
happened w/o Xorg ever being run during that session (though naturally the 
nvidia kernel module was still loaded).

So long,
Matthias
