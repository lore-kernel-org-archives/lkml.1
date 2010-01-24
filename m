Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142Ab0AXWd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0AXWd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807Ab0AXWd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:33:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0AXWd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:33:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #15126] REGRESSION for RT2561/RT61 in 2.6.33
Date: Sun, 24 Jan 2010 23:34:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
References: <Pine.LNX.4.44L0.1001241730360.441-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001241730360.441-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001242334.46566.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Alan Stern wrote:
> On Sun, 24 Jan 2010, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15126
> > Subject		: REGRESSION for RT2561/RT61 in 2.6.33
> > Submitter	: Alan Stern <stern@rowland.harvard.edu>
> > Date		: 2010-01-11 14:54 (14 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126322167427159&w=4
> > Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> 
> This bug entry can be removed from the list.  It turned out not to be 
> a bug at all, just a kernel config error I made when updating to 
> 2.6.33-rc1.

Thanks, closed as "invalid".

Rafael
