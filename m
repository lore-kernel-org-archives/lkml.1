Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZBIKaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZBIKaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZBIKaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:30:08 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43493 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZBIKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:30:06 -0500
Date: Mon, 9 Feb 2009 10:25:46 +0000 (GMT)
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
In-Reply-To: <sWhNs83kKPE.A.E5F.w20jJB@chimera>
Message-ID: <Pine.LNX.4.64.0902091024520.14410@blonde.anvils>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.E5F.w20jJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
> Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-01-23 23:52 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
> 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> 		  Hugh Dickins <hugh@veritas.com>
> 		  Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123412278730735&w=4

Please still list it for now, but I expect Sergei's and Alan's fixes
to be in -rc5.

Hugh
