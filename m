Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZJ0UWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZJ0UWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZJ0UWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:22:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbZJ0UWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:22:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Paris <eparis@parisplace.org>
Subject: Re: [Bug #14090] WARNING: at fs/notify/inotify/inotify_user.c:394
Date: Tue, 27 Oct 2009 21:24:17 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Joerg Platte <bugzilla@jako.ping.de>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.1J.5ff5KB@chimera> <7e0fb38c0910270733g7b05c779m1f593529659a6ff@mail.gmail.com>
In-Reply-To: <7e0fb38c0910270733g7b05c779m1f593529659a6ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910272124.17796.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Eric Paris wrote:
> On Mon, Oct 26, 2009 at 3:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14090
> > Subject         : WARNING: at fs/notify/inotify/inotify_user.c:394
> > Submitter       : Joerg Platte <bugzilla@jako.ping.de>
> > Date            : 2009-08-30 15:21 (58 days old)
> 
> should be fixed by: 9f0d793b52eb2266359661369ef6303838904855 in linus' tree

Thanks, closing.

Rafael
