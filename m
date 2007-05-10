Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXEJRF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXEJRF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761307AbXEJRFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:05:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761141AbXEJRFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:05:39 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v11
Date: Thu, 10 May 2007 18:59:11 +0200
User-Agent: KMail/1.9.6
References: <20070508150431.GA26977@elte.hu>
In-Reply-To: <20070508150431.GA26977@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101859.11696.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX1+Fhgybdhhf95oA6G3teobC3gZqvEA0z6hm0Ie
 VmkT/Ib3FlO7/Rm7e4ipQ9XkhOXHUsraOIl2zIifHJ5WLKNFM9
 4R/eWZTJ5WufE2E4E6NHg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml, hello Ingo!

I've been using CFS-v10 for a few days and I must say that I'm verry 
impressed ;-)

Desktop performance without any manual renicing is excellent, even with 
make -j20. Gaming performance is at least on par with SD now! I've tried to 
change the sched_load_smoothing config to "8" but there is no visible 
difference when it's set to "7".

Both schedulers are verrry good! I can't really tell which one is better.
I noticed that while compiling a kernel (with -j4) my CPU temperature is two 
to three degrees hotter than with mainline. I have not done any timing tests, 
but I suspect that it's a little faster while preserving excellent desktop 
usability. Great work!! :-)

-Christian
