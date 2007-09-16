Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXIPT4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXIPT4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbXIPT4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:56:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51944 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbXIPT4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:56:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI video mode patch review
Date: Sun, 16 Sep 2007 22:08:03 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46E9AD88.7070400@zytor.com>
In-Reply-To: <46E9AD88.7070400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162208.03768.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 September 2007 23:37, H. Peter Anvin wrote:
> Pavel, want to look at the patch before sending it to Linus?

Many thanks for taking care of this!

We already have a patch in -mm, s2ram-kill-old-debugging-junk.patch from Pavel
(http://marc.info/?l=linux-mm-commits&m=118737955611331&w=1), that removes the
#ifdefed blocks and it clashes with your first patch a bit.

FYI, I have rebased your first patch on top of the Pavel's patch:
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc6/patches/39-acpi-video-mode-fix.patch

Greetings,
Rafael
