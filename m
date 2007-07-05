Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXGEOQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXGEOQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXGEOQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:16:16 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:50340 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbXGEOQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:16:15 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707051614.19300.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051531.37532.rjw@sisk.pl> <E1I6RjE-0000pP-00@dorka.pomaz.szeredi.hu> <200707051614.19300.rjw@sisk.pl>
Message-Id: <E1I6S6d-0000tl-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 16:14:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I guess I know your answer.  But it ain't gonna work.  Suspend code
> > really doesn't belong in VFS, and I'm pretty sure the maintainers of
> > that little piece of code would agree with me on this.
> 
> Surprise, surprise.  Not that I'm scared of the VFS maintainers, though. ;-)

Probably you haven't had a close encounter with them yet.  They are
pretty much the _most_ dangerous people in kernel land ;)

Miklos
