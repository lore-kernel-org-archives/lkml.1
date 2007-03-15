Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXCOBPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXCOBPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXCOBPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:15:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422799AbXCOBPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:15:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mingo@elte.hu,
       akpm@osdl.org, stable@kernel.org, greg@kroah.com
Subject: Re: [PATCH] Fix COMPAT_VDSO regression bug
In-Reply-To: Leroy van Logchem's message of  Thursday, 15 March 2007 00:38:40 +0100 <45F88780.1080507@wldelft.nl>
X-Shopping-List: (1) Ancient pajamas
   (2) Unreliable sporadic explosions
   (3) Heterogeneous ball furniture
   (4) Cinematic trout
Message-Id: <20070315011512.9FF851801C5@magilla.sf.frob.com>
Date: Wed, 14 Mar 2007 18:15:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I built a CONFIG_COMPAT_VDSO=y, CONFIG_HIGHMEM64G=y kernel and it has no
problems with FC-6 userland.  Everything looks fine with the vDSO.  
So either some more details of your kernel config are relevant, or
something about the userland usage pattern.


Thanks,
Roland
