Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014Ab0AKTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0AKTu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895Ab0AKTu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:50:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0AKTu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:50:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #14896] REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
Date: Mon, 11 Jan 2010 20:51:06 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
References: <Pine.LNX.4.44L0.1001110957440.2873-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001110957440.2873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112051.06963.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Alan Stern wrote:
> On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14896
> > Subject		: REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
> > Submitter	: Alan Stern <stern@rowland.harvard.edu>
> > Date		: 2009-12-06 22:12 (36 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126013756829691&w=4
> > Handled-By	: Gertjan van Wingerde <gwingerde@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/67338/
> 
> This has been fixed by commit 93b6bd26b74efe46b4579592560f9f1cb7b61994.

Thanks, closing.

Rafael
