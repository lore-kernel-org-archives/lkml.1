Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbZJMUv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbZJMUv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761049AbZJMUv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:51:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43877 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759910AbZJMUv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:51:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Bug #14389] Build system issue
Date: Tue, 13 Oct 2009 22:52:59 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Peter Zijlstra <peterz@infradead.org>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <r-4Wjt4coy.A.r3B.Ial0KB@chimera> <20091013185313.GB5249@merkur.ravnborg.org>
In-Reply-To: <20091013185313.GB5249@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132252.59779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Sam Ravnborg wrote:
> On Mon, Oct 12, 2009 at 12:22:09AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14389
> > Subject		: Build system issue
> > Submitter	: Peter Zijlstra <peterz@infradead.org>
> > Date		: 2009-10-09 8:58 (3 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=575543347b5baed0ca927cb90ba8807396fe9cc9
> > References	: http://marc.info/?l=linux-kernel&m=125507914909152&w=4
> 
> It is fixed by: 2331d1a6cd3d6e580bc88b9a160066d9e1177fe1
> 
> I did not have the bug-entry when the changelog was written
> so no references there.

Thanks, closing.

Rafael
