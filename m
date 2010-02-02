Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0BBUjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:39:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0BBUjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:39:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #15144] HDA Intel Audio hang on boot
Date: Tue, 2 Feb 2010 21:40:06 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: sboyce@blueyonder.co.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <4B6635F1.8060909@blueyonder.co.uk> <s5h3a1lh2wr.wl%tiwai@suse.de>
In-Reply-To: <s5h3a1lh2wr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022140.06721.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Takashi Iwai wrote:
> At Mon, 01 Feb 2010 02:01:21 +0000,
> Sid Boyce wrote:
> > 
> > On 01/02/10 00:22, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15144
> > > Subject		: HDA Intel Audio hang on boot
> > > Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
> > > Date		: 2010-01-15 1:24 (17 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126351866722507&w=4
> > > 
> > > 
> > > 
> > 
> > Still not fixed in 2.6.33-rc6. Takashi wrote that the fix was scheduled
> > for 2.6.33-rc6, but it did not appear.
> 
> It just slipped from rc6 due to my busy load.
> The pull request was sent yesterday.

Linus has already merged it, so I've closed the bug.

Rafael
