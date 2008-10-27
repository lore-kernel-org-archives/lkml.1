Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYJ0UTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYJ0UTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYJ0UTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:19:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYJ0UTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:19:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [Bug #11851] wmifinfo dockapp takes 100% of cpu
Date: Mon, 27 Oct 2008 21:23:59 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.ltB.aV5AJB@chimera> <20081027194328.GA4353@localhost.aei.mpg.de>
In-Reply-To: <20081027194328.GA4353@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810272124.00303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> On Sat 25.Oct'08 at 22:06:49 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11851
> > Subject		: wmifinfo dockapp takes 100% of cpu
> > Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> > Date		: 2008-10-25 9:40 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122492763030453&w=4
> > Handled-By	: Arjan van de Ven <arjan@linux.intel.com>
> > 		  Marcin Slusarz <marcin.slusarz@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=122496409612709&w=4
> 
> 
> Fixed by commit 4d36a9e65d4966b433b2f3424d9457468bc80e00 

Thanks, closed.

Rafael



