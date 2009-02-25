Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbZBYWuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbZBYWuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZBYWuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:50:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZBYWuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:50:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12393] debugging in dosemu causes lots of 'scheduling while atomic'
Date: Wed, 25 Feb 2009 23:49:39 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michal Suchanek <hramrach@centrum.cz>, Stable Team <stable@kernel.org>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <LLno3yT_fnC.A.dl.6zzoJB@chimera> <alpine.LFD.2.00.0902241101580.3523@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902241101580.3523@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902252349.40563.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Thomas Gleixner wrote:
> On Mon, 23 Feb 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12393
> > Subject		: debugging in dosemu causes lots of 'scheduling while atomic'
> > Submitter	: Michal Suchanek <hramrach@centrum.cz>
> > Date		: 2009-01-09 07:28 (46 days old)
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> > Patch		: http://lkml.org/lkml/2009/1/13/445
> 
> Commit be716615fe596ee117292dc615e95f707fb67fd1 in Linus tree.
> 
> "Cc: stable@kernel.org" is in the commit log, so stable folks should
> have it as well.

Thanks, closed.

Rafael
