Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZFAUdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZFAUdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZFAUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:32:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56123 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZFAUc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:32:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #13372] Oops in usb-serial with keyspan adapter
Date: Mon, 1 Jun 2009 22:33:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       USB <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0905311046340.31316-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905311046340.31316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012233.10128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009, Alan Stern wrote:
> On Sat, 30 May 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13372
> > Subject		: Oops in usb-serial with keyspan adapter
> > Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date		: 2009-05-18 0:07 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124260532924736&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > Patch		: http://patchwork.kernel.org/patch/26603/
> 
> That URL points to a patch for a different problem.  The "Oops in
> usb-serial with keyspan adapter" has been fixed by commit
> 0a3c8549ea7e94d74a41096d42bc6cdf43d183bf.

Thanks, I've closed the bug.

Best,
Rafael
