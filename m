Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbZJLVrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbZJLVrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbZJLVrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:47:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36405 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZJLVrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:47:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: 2.6.32-rc4: Reported regressions 2.6.30 -> 2.6.31
Date: Mon, 12 Oct 2009 23:48:33 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <1255377529.9544.63.camel@bluto.andrew>
In-Reply-To: <1255377529.9544.63.camel@bluto.andrew>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122348.33588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Andrew Patterson wrote:
> On Mon, 2009-10-12 at 00:41 +0200, Rafael J. Wysocki wrote:
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14309
> > Subject		: MCA on hp rx8640
> > Submitter	: Andrew Patterson <andrew.patterson@hp.com>
> > Date		: 2009-09-29 17:20 (13 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db8be50c4307dac2b37305fc59c8dc0f978d09ea
> > References	: http://www.spinics.net/lists/linux-usb/msg22799.html
> > 
> 
> Linus fixed this one with d93a8f829fe1d2f3002f2c6ddb553d12db420412.  It
> also looks like a duplicate of
> http://bugzilla.kernel.org/show_bug.cgi?id=14374

Thanks, I closed #14309 as a duplicate of #14374 that's already closed.

Best,
Rafael
