Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZBXBi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZBXBi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZBXBiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:38:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43121 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbZBXBiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:38:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Date: Tue, 24 Feb 2009 02:37:43 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.-RH.ZzzoJB@chimera> <1235437183.4988.2.camel@kulgan.wumi.org.au>
In-Reply-To: <1235437183.4988.2.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240237.44916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Kevin Shanahan wrote:
> On Mon, 2009-02-23 at 23:03 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Yes, the problem should still be listed.
> The bug is still present as recently as 2.6.29-rc5-00299-gadfafef.

Thanks for the update.

Rafael
