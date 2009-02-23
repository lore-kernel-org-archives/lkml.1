Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZBWKxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZBWKxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZBWKxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:53:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZBWKxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:53:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 11:52:53 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902221603440.3111@localhost.localdomain> <alpine.LFD.2.00.0902221722100.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902221722100.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231152.53928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Linus Torvalds wrote:
> 
> On Sun, 22 Feb 2009, Linus Torvalds wrote:
> > 
> > Ok, looks sane to me. I'll try it on my poor eeepc, although right now 
> > Fedora-11 rawhide (that poor laptop gets _all_ the crazy stuff thrown at 
> > it, and runs btrfs to boot) has broken something in X by enabling DRI2, so 
> > I may not get around to it today.
> 
> Well, the suspend/resume part seems to work for me.

Great, thanks for testing.

Rafael
