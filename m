Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0BHBMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 20:12:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab0BHBMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 20:12:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Date: Mon, 8 Feb 2010 02:12:52 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <iuJeop2ribM.A.mRC._a1bLB@chimera> <4B6F62BE.1090803@gmail.com>
In-Reply-To: <4B6F62BE.1090803@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002080212.52914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Justin P. Mattock wrote:
> On 02/07/10 16:28, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> > Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> > Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> > Date		: 2009-10-23 16:45 (108 days old)
> > References	: http://lkml.org/lkml/2009/10/23/252
> > Handled-By	: Jan Beulich<jbeulich@novell.com>
> > Patch		: http://patchwork.kernel.org/patch/68719/
> >
> >
> >
> 
> 
> the patch attached to the bug report
> makes my machine boot up with out a
> Panic, and allows me to do remote debugging
> via ohci1394_dma.
> 
> I did see a call trace as I was debugging
> which might be related to having one
> system using the patch, and the other not.
> but still need to look at that.
> (only saw this once out of numerous boots
> (could be a rarity)).

Thanks for the update.

Rafael
