Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbZDQVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbZDQVgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZDQVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:36:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbZDQVgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:36:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Fri, 17 Apr 2009 23:36:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, laurent.pinchart@skynet.be,
       mchehab@infradead.org
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com>
In-Reply-To: <d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172336.12414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Ming Lei wrote:
> 2009/4/17 Rafael J. Wysocki <rjw@sisk.pl>:
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13125
> > Subject         : active uvcvideo breaks over suspend
> > Submitter       : Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date            : 2009-04-15 10:12 (2 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123979009508840&w=4
> >
> 
> It is a bug in resume path of uvcvideo driver, and I have sent a patch
> to laurent.pinchart@skynet.be,
> mchehab@infradead.org  and video4linux-list@redhat.com to fix it, but
> still no echo from them.
> 
> The patch title is V4L/DVB:usbvideo:fix uvc resume failed.
> 
> Rafael J.
>         If you would like to apply it ,I can resend to you.  Thanks!

Please resend.

Rafael
