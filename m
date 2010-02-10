Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0BJTW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:22:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab0BJTW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:22:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [Bug #15195] kernel BUG at include/net/netns/generic.h:41, pfkey_create+0x36/0x18b [af_key]
Date: Wed, 10 Feb 2010 20:23:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.4VB.YozbLB@chimera> <68676e01002100759v37f79938p51f3aeb6c068d39a@mail.gmail.com>
In-Reply-To: <68676e01002100759v37f79938p51f3aeb6c068d39a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002102023.34292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010, Luca Tettamanti wrote:
> On Sun, Feb 7, 2010 at 11:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15195
> > Subject         : kernel BUG at include/net/netns/generic.h:41, pfkey_create+0x36/0x18b [af_key]
> > Submitter       : Luca Tettamanti <kronos.it@gmail.com>
> > Date            : 2010-01-30 13:23 (9 days old)
> > References      : http://marc.info/?l=linux-netdev&m=126485785004775&w=4
> > Handled-By      : Alexey Dobriyan <adobriyan@gmail.com>
> > Patch           : http://patchwork.kernel.org/patch/75891/
> 
> Fixed by commit 180211b841b5bf13ab10d19202adab3eb7749f6c

Thanks, closing.

Rafael
