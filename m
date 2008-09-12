Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYILVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYILVOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYILVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:14:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYILVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:14:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Bug #11276] build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Date: Fri, 12 Sep 2008 23:19:17 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.W3.8esyIB@albercik> <48CAD51D.4060908@oracle.com>
In-Reply-To: <48CAD51D.4060908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809122319.18633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 of September 2008, Randy Dunlap wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
> > Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2008-08-06 17:18 (38 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
> > 		  http://lkml.org/lkml/2008/7/22/353
> > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Patch		: http://lkml.org/lkml/2008/7/22/364
> 
> Yes, I still see this build error.
> What would it take to have Bjorn's patch merged into mainline?

Well, send a request to Andrew I think (with the patch appended).

Thanks,
Rafael
