Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbZBERcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbZBERcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZBERbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:31:42 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42456 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036AbZBERbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:31:41 -0500
Date: Thu, 5 Feb 2009 17:30:49 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
In-Reply-To: <pWZw1SZjMCH.A.o-D.uuYiJB@chimera>
Message-ID: <Pine.LNX.4.64.0902051723520.1445@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.o-D.uuYiJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
> Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-01-23 23:52 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
> 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> 		  Hugh Dickins <hugh@veritas.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123254501314058&w=2

Yes, this does still need to be listed.  My initial patch for it was
not enough, but I think the three patches necessary have all now been
posted (though Sergei may rewrite mine).  I'm expecting Alan to gather
them together and send them in due course, but I believe he's occupied
with other stuff just at the moment.

Hugh
