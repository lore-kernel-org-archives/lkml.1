Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674Ab0AXWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0AXWc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001Ab0AXWc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:32:26 -0500
Received: from netrider.rowland.org ([192.131.102.5]:56679 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752447Ab0AXWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:32:25 -0500
Date: Sun, 24 Jan 2010 17:32:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #15126] REGRESSION for RT2561/RT61 in 2.6.33
In-Reply-To: <hE3x9c-4KZM.A.EdF.BKMXLB@chimera>
Message-ID: <Pine.LNX.4.44L0.1001241730360.441-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15126
> Subject		: REGRESSION for RT2561/RT61 in 2.6.33
> Submitter	: Alan Stern <stern@rowland.harvard.edu>
> Date		: 2010-01-11 14:54 (14 days old)
> References	: http://marc.info/?l=linux-kernel&m=126322167427159&w=4
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>

This bug entry can be removed from the list.  It turned out not to be 
a bug at all, just a kernel config error I made when updating to 
2.6.33-rc1.

Alan Stern

