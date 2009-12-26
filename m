Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbZLZOIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbZLZOIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 09:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbZLZOIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 09:08:37 -0500
Received: from lo.gmane.org ([80.91.229.12]:57879 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZLZOIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 09:08:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [RFT] Input: speed up suspend/shutdown for PS/2 mice and keyboards
Date: Sat, 26 Dec 2009 13:40:06 +0000
Message-ID: <magh07-258.ln1@chipmunk.wormnet.eu>
References: <20091221070951.GA4170@core.coreip.homeip.net>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> I am asking everyone to give this patch a try. It is reported to speed
> up suspend process, however there is a risk that there are boxes out
> there that do require full reset and I would prefer to know that sooner
> than later.
> 
Seems to work on my ICH8 lapdog (a Fujitsu T2010), can't say it actually 
speeds the suspend/resume cycle up though.

Cheers

-- 
Alexander Clouter
.sigmonster says: Bus error -- driver executed.

