Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083Ab0AKT5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0AKT5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049Ab0AKT5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:57:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0AKT5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:57:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
Date: Mon, 11 Jan 2010 20:58:01 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Fruhwirth Clemens <clemens@endorphin.org>
References: <Pine.LNX.4.44L0.1001111008080.2873-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001111008080.2873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112058.01652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Alan Stern wrote:
> On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14841
> > Subject	: unable to enumerate USB device on port X after suspend/resume
> > Submitter	: Fruhwirth Clemens <clemens@endorphin.org>
> > Date		: 2009-12-19 11:45 (23 days old)
> 
> This bug has been resolved as WILL NOT FIX.  It ended up having nothing
> to do with suspend or resume, it was caused by strange behavior in the
> device hardware.

Thanks, closed.

Rafael
