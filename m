Return-Path: <linux-kernel-owner+w=401wt.eu-S932154Ab0AEVgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab0AEVgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375Ab0AEVgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:36:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0AEVgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:36:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [Bug #14938] Unable to handle kernel paging request in radeon_fence_signaled
Date: Tue, 5 Jan 2010 22:36:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.ibG.GnhOLB@chimera> <201001050026.31509.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <201001050026.31509.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001052236.37215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Johannes Hirte wrote:
> Am Dienstag 29 Dezember 2009 16:10:01 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14938
> > Subject		: Unable to handle kernel paging request in 
> radeon_fence_signaled
> > Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
> > Date		: 2009-12-27 13:40 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126192123104047&w=4
> 
> This should be the same as http://bugzilla.kernel.org/show_bug.cgi?id=14910.

Thanks, closed as a duplicate.

Rafael
