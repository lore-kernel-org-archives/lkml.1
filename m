Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZEaOsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZEaOsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZEaOsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:48:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41898 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751554AbZEaOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:48:13 -0400
Date: Sun, 31 May 2009 10:48:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       USB <linux-usb@vger.kernel.org>
Subject: Re: [Bug #13372] Oops in usb-serial with keyspan adapter
In-Reply-To: <LEcEO2518_I.A.xsD.1IbIKB@chimera>
Message-ID: <Pine.LNX.4.44L0.0905311046340.31316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13372
> Subject		: Oops in usb-serial with keyspan adapter
> Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date		: 2009-05-18 0:07 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=124260532924736&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://patchwork.kernel.org/patch/26603/

That URL points to a patch for a different problem.  The "Oops in
usb-serial with keyspan adapter" has been fixed by commit
0a3c8549ea7e94d74a41096d42bc6cdf43d183bf.

Alan Stern

