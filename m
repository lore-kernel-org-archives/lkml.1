Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468Ab0AYGcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab0AYGcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200Ab0AYGcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:32:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab0AYGcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:32:46 -0500
Subject: Re: [Bug #15017] kexec regression, radeon/kms irq related
 (bisected)
From: Dave Airlie <airlied@redhat.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <a728f9f91001241926m4c19aedbvda295fe3c7daade@mail.gmail.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	 <hE3x9c-4KZM.A.kWG.mKMXLB@chimera>
	 <a728f9f91001241926m4c19aedbvda295fe3c7daade@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 16:28:18 +1000
Message-ID: <1264400898.8478.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-24 at 22:26 -0500, Alex Deucher wrote:
> On Sun, Jan 24, 2010 at 5:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15017
> > Subject         : kexec regression, radeon/kms irq related (bisected)
> > Submitter       : Markus Trippelsdorf <markus@trippelsdorf.de>
> > Date            : 2010-01-09 18:49 (16 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d8f60cfc93452d0554f6a701aa8e3236cbee4636
> >
> >
> >
> 
> That bug has patches which fix the issue attached and queued for 2.6.33.

Just sent to Linus.

Dave.


