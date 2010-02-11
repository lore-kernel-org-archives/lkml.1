Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0BKKiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:38:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0BKKix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:38:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidjon@xenontk.org
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid context
Date: Thu, 11 Feb 2010 11:39:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <iuJeop2ribM.A.DgH.XY1bLB@chimera> <4B736FD3.2000707@xenontk.org>
In-Reply-To: <4B736FD3.2000707@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002111139.28365.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, David John wrote:
> On 02/08/2010 05:58 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
> > Subject		: Bluetooth: sleeping function called from invalid context
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2010-01-12 9:19 (27 days old)
> > First-Bad-Commit: http://git.kernel.org/git/linus/9e726b17422bade75fba94e625cd35fd1353e682
> > References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
> > Handled-By	: Marcel Holtmann <marcel@holtmann.org>
> > Patch		: http://patchwork.kernel.org/patch/76019/
> > 
> > 
> > 
> 
> Hi Rafael,
> 
> This bug is now fixed by the upstream commit 485f1e ("Bluetooth: Fix
> sleeping function in RFCOMM within invalid context") and can be closed.

Thanks, closing.

Rafael
