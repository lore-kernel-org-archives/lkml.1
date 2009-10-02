Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZJBROu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZJBROu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZJBROt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:14:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35630 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZJBROs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:14:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #13935] 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
Date: Fri, 2 Oct 2009 19:16:16 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Adrian Ulrich <kernel@blinkenlights.ch>,
       Jan Scholz <Scholz@fias.uni-frankfurt.de>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.DPD.fOTxKB@chimera> <alpine.LSU.2.00.0910021757390.10941@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910021757390.10941@wotan.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021916.16850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Jiri Kosina wrote:
> On Thu, 1 Oct 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
> > Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
> > Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
> > Date		: 2009-08-08 22:08 (55 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343
> 
> Fixed now in Linus' tree (42960a13) and submitted for stable. Please 
> close.

Done.

Thanks,
Rafael
