Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZDPUTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZDPUTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZDPUS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:18:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbZDPUS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:18:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Thu, 16 Apr 2009 22:18:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904151402460.4042@localhost.localdomain> <s5hfxg92kwa.wl%tiwai@suse.de>
In-Reply-To: <s5hfxg92kwa.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904162218.26340.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009, Takashi Iwai wrote:
> At Wed, 15 Apr 2009 14:05:20 -0700 (PDT),
> Linus Torvalds wrote:
> > 
> > 
> > 
> > On Wed, 15 Apr 2009, Rafael J. Wysocki wrote:
> > > 
> > > I'm going to try 2.6.30-rc2-git in a while.  If I have the time, I'll also test
> > > the sound git tree.
> > 
> > There's a sound merge today (ie post-rc2) which hopefully contains the 
> > relevant fixes. 
> 
> Yep, they are in.

I've been running the post-rc2 kernel containing these changes for several
hours without any visible problems.

Thanks,
Rafael
