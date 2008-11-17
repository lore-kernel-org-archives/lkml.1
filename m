Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYKQWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYKQWSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYKQWSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:18:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48500 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYKQWSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:18:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [Bug #12038] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Mon, 17 Nov 2008 23:23:29 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.sUE.LAGIJB@chimera> <20081117220851.GA6314@dose.home.local>
In-Reply-To: <20081117220851.GA6314@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172323.30272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 17 of November 2008, Tino Keitel wrote:
> On Sun, Nov 16, 2008 at 17:35:21 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12038
> > Subject		: Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
> > Submitter	: Tino Keitel <tino.keitel@gmx.de>
> > Date		: 2008-11-09 20:28 (8 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=66036f5862883fcc9f7ff8550685a5a3de1a57e4
> > References	: http://marc.info/?l=linux-kernel&m=122626258429689&w=4
> > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > Patch		: http://marc.info/?l=linux-kernel&m=122661443120581&w=4
> 
> The patch works fine here. I applied it to 2.6.27.5 and resume works.

Thanks for testing, I'm going to push it upstream shortly.

Best,
Rafael
