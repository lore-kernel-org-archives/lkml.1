Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0BOUzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:55:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36450 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab0BOUz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:55:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Bug #15177] Asynchronous writes up to 30% slower than in previous kernel versions
Date: Mon, 15 Feb 2010 21:55:56 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera> <4un6Gst5rKB.A.FwH.TjIeLB@chimera> <e2e108261002142309m79648ccbo3779c43ac7e6ab4a@mail.gmail.com>
In-Reply-To: <e2e108261002142309m79648ccbo3779c43ac7e6ab4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152155.56859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010, Bart Van Assche wrote:
> On Mon, Feb 15, 2010 at 12:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15177
> > Subject         : Asynchronous writes up to 30% slower than in previous kernel versions
> > Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> > Date            : 2010-01-30 16:38 (16 days old)
> 
> Hello Rafael,
> 
> I thought your plan was to move this item to the 2.6.28 regression
> list ? See also
> http://groups.google.com/group/linux.kernel/msg/474762980e717a13?pli=1.

Thanks for reminding me about that, done now.

Rafael
