Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981Ab0ALWCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0ALWCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475Ab0ALWB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:01:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42942 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0ALWB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:01:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Engel <jcnengel@googlemail.com>
Subject: Re: 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
Date: Tue, 12 Jan 2010 23:02:17 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <4B4CB3B5.3060900@googlemail.com>
In-Reply-To: <4B4CB3B5.3060900@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001122302.17835.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 January 2010, Johannes Engel wrote:
> On 10.01.2010 23:45, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions introduced between 2.6.31 and
> > 2.6.32, for which there are no fixes in the mainline I know of.  If any of them
> > have been fixed already, please let me know.
> >
> > If you know of any other unresolved regressions introduced between 2.6.31
> > and 2.6.32, please let me know either and I'll add them to the list.
> >   
> How about #15004?

Qualifies, but I need to know the last working kernel.

Rafael
