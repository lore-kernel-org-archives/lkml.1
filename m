Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZDFWey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZDFWey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbZDFWel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:34:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbZDFWei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:34:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
Date: Tue, 7 Apr 2009 00:34:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Trenton Adams <trenton.d.adams@gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904070035.00784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Linus Torvalds wrote:
> 
> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13019
> > Subject		: /proc/<pid>/maps offset output broken in 2.6.29
> > Submitter	: "Chris Friesen" <cfriesen@nortel.com>
> > Date		: 2009-04-01 23:18 (6 days old)
> > References	: http://marc.info/?l=linuxppc-embedded&m=123862902916059&w=4
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> 
> I don't think that's a regression, nor really a bug. It looks cosmetic, 
> and likely to be fixed, but not really worth worrying about.

OK, I've dropped it from the list.

Thanks,
Rafael
