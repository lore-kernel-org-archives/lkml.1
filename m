Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0BNX0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:26:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0BNX0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:26:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bret Towe <magnade@gmail.com>
Subject: Re: reiserfs issue with 2.6.32.8
Date: Mon, 15 Feb 2010 00:27:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
In-Reply-To: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150027.00124.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, Bret Towe wrote:
> I recently attempted upgrading from 2.6.31.6 to 2.6.32.8 on a local server
> that runs several filesystems and when trying to move or copy or create a file
> on a reiserfs system that was sitting on lvm over raid5(not sure if
> that matters)
> I would get mv or cp to return Invalid Argument and not doing anything
> moving files from xfs to xfs worked fine tho
> 
> for now I went back to .31.6 I'm willing to test any patches required
> any config info or what not let me know and I'll dig it up
> dmesg was clean

I have created the Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15309
for your report.

Thanks,
Rafael
