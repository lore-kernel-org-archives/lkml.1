Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZJZWM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZJZWM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbZJZWM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:12:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60835 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZJZWM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:12:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: q-funk@iki.fi
Subject: Re: [Bug #13941] x86 Geode issue
Date: Mon, 26 Oct 2009 23:14:52 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.Zs.mgf5KB@chimera> <11fae7c70910261432w27b39e92ld319487e679fccaa@mail.gmail.com>
In-Reply-To: <11fae7c70910261432w27b39e92ld319487e679fccaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910262314.52086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Martin-Éric Racine wrote:
> I do not recall anyone on LKML actually ever doing any work towards
> fixing this issue so, yes, it is still open.

Thanks for the update.

Rafael


> On Mon, Oct 26, 2009 at 9:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13941
> > Subject         : x86 Geode issue
> > Submitter       : Martin-Éric Racine <q-funk@iki.fi>
> > Date            : 2009-08-03 12:58 (85 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
