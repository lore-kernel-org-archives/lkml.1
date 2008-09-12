Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbYILUlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbYILUlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYILUky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:40:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYILUky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:40:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Date: Fri, 12 Sep 2008 22:45:44 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>
References: <20080912083113.GA1625@elf.ucw.cz> <200809122117.05750.rjw@sisk.pl> <alpine.LFD.1.10.0809122113270.13819@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809122113270.13819@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809122245.45723.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 of September 2008, Thomas Gleixner wrote:
> On Fri, 12 Sep 2008, Rafael J. Wysocki wrote:
> 
> > On Friday, 12 of September 2008, Pavel Machek wrote:
> > > Hi!
> > > 
> > > The old "you have to press keys to get machine to progress" seems to
> > > be back :-(. Thinkpad x60.
> > 
> > I guess the last bunch of HPET/clockevents patches caused that to happen.
> 
> Guessing is hardly a good method to get down to the root cause of
> those problems.

Well, sure.

> > We seem to be doing a "one step forward, one step back" thing here ...
> 
> Well, the fixes for HPET/clockevents fix real bugs and there are no
> evident side effects vs. s2ram inside. quite the contrary.

So that must be something different.

Thanks,
Rafael
