Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZFGUut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZFGUut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFGUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:50:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59732 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZFGUuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:50:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [Bug #13072] forcedeth seems to switch off eth on shutdown
Date: Sun, 7 Jun 2009 22:50:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Bierstedt <daniel.bierstedt-Mmb7MZpHnFY@public.gmane.org>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.ELC.ck7KKB@chimera> <4A2BF577.1050003@gmail.com>
In-Reply-To: <4A2BF577.1050003@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072250.39558.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Robert Hancock wrote:
> 
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13072
> > Subject		: forcedeth seems to switch off eth on shutdown
> > Submitter	: Daniel Bierstedt <daniel.bierstedt-Mmb7MZpHnFY@public.gmane.org>
> > Date		: 2009-04-12 07:00 (57 days old)
> 
> Seems like it should be fixed by:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5a9a8e32ebe269c71d8d3e78f9435fe7729f38e9

Thanks, I've closed the bug.

Rafael
