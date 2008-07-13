Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYGMTeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYGMTeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGMTe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:34:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39772 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbYGMTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:34:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #10725] USB Mass storage mount fails: Write protect on
Date: Sun, 13 Jul 2008 21:36:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Pine.LNX.4.44L0.0807131528180.4671-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807131528180.4671-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807132136.23158.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of July 2008, Alan Stern wrote:
> On Sun, 13 Jul 2008, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
> > Subject		: USB Mass storage mount fails: Write protect on
> > Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date		: 2008-05-16 14:55 (59 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > Patch		: http://marc.info/?l=linux-scsi&m=121433068314568&w=2
> 
> This can be removed.  It was fixed by commit 
> bdb2b8cab4392ce41ddfbd6773a3da3334daf836.

Thanks, closed.

Rafael
