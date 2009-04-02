Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbZDBPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbZDBPtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZDBPt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:49:26 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:39612 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZDBPtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:49:25 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #12872] pwc mmap always fails with EAGAIN
Date: Thu, 2 Apr 2009 17:49:21 +0200
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <200903222058.12924.M4rkusXXL@web.de> <20090322200521.GA5355@elte.hu>
In-Reply-To: <20090322200521.GA5355@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021749.22100.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX19/rU1MBmTP5w2nwQ7CadSHm6iPpoUg47bo67uz
	3Qmr8vwa9tBEeRBJJfmYjgHILq3/SHDXX0K/t4Cs6hfNTWo5VF
	MY1cxAplc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First thing to check would be whether the latest round of PAT fixes 
> (not yet upstream) fix the problem:

I checked 2.6.29 (the vanilla release) it still has this regression.

I also checked your "tip"-version and it works! (Built the kernel on 
march the 25th. But got no time to test it... up to now...)

Markus
