Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0BHTgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:36:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab0BHTgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:36:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Bug #15177] Asynchronous writes up to 30% slower than in previous kernel versions
Date: Mon, 8 Feb 2010 20:37:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.2jB.iozbLB@chimera> <e2e108261002081116m5c13d081p161d8697464253f1@mail.gmail.com>
In-Reply-To: <e2e108261002081116m5c13d081p161d8697464253f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002082037.49793.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Bart Van Assche wrote:
> On Sun, Feb 7, 2010 at 11:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> > Date            : 2010-01-30 16:38 (9 days old)
> 
> The regression compared to 2.6.32 is solved in 2.6.33-rc7 for the
> specific test mentioned in the Bugzilla entry. The regression compared
> to 2.6.28 is not yet solved though, so I'm not sure what should happen
> with this bug entry.

I guess it's better to move it to the list of regressions from 2.6.28.

Rafael
