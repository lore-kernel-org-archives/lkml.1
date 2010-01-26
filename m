Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040Ab0AZMmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0AZMmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203Ab0AZMml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:42:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0AZMmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:42:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #15040] High cpu temperature with 2.6.32
Date: Tue, 26 Jan 2010 13:43:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Dimitrios Apostolou <jimis@gmx.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <201001252152.33031.rjw@sisk.pl> <20100125214150.1f2e1410@infradead.org>
In-Reply-To: <20100125214150.1f2e1410@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261343.15685.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Arjan van de Ven wrote:
> On Mon, 25 Jan 2010 21:52:32 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday 25 January 2010, Dimitrios Apostolou wrote:
> > > I will let you know when this bug is fixed in a regular kernel
> > > release. I just tested 2.6.32.5 and the bug persists. BTW, Arjan, I
> > > think this bug will be biting other people too, see the following
> > > thread: http://bugs.archlinux.org/task/17771
> > 
> > I don't think it's fixed, I haven't seen the Arjan's patch anywhere
> > close to the mainline.
> > 
> > Arjan, perhaps send it directly to Linus, please (unless it's already
> > waiting somewhere for merging)?
> 
> I sent it to Len and Andrew (Len as maintainer, Andrew as maintainer of
> last resort)..... what more would I need?

Well, Andrew, do you have the patch at http://patchwork.kernel.org/patch/71962/
in your queue?  It's a regression fix.

Rafael
