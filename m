Return-Path: <linux-kernel-owner+w=401wt.eu-S1751335Ab0AWUPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0AWUPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081Ab0AWUPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:15:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab0AWUPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:15:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [REGRESSION] clockevents patch causes hang on power off
Date: Sat, 23 Jan 2010 21:16:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Nathan Williams <ngwilliams@gmail.com>,
       "Ozan ??a??layan" <ozan@pardus.org.tr>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com> <b4e196fa1001230322u558f7af5j5f27844088895a0@mail.gmail.com> <20100123152421.GA15855@suse.de>
In-Reply-To: <20100123152421.GA15855@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001232116.27003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 January 2010, Greg KH wrote:
> On Sat, Jan 23, 2010 at 10:22:10PM +1100, Nathan Williams wrote:
> > 2010/1/23 Ozan ??a??layan <ozan@pardus.org.tr>:
> > > Nathan Williams wrote:
> > >> I'm having trouble with my PC crashing just as it's attempting to power off.
> > >> I managed to git bisect to this commit:
> > >>
> > >
> > > http://bugzilla.kernel.org/show_bug.cgi?id=15037
> > > http://patchwork.kernel.org/patch/71537/
> > >
> > 
> > Thanks. The patch works for me.
> 
> What's the plan on getting that patch into Linus's tree for .33?

Well, I guess please send it to Linus with the appropriate CC list.

This is a regression that we need to address ASAP, the patch is known, no
one has objected, so the thing is pretty much clear.

Rafael
