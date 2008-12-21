Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYLUT4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYLUT4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYLUT4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:56:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52200 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYLUT4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:56:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #12099] Nokia 5310 storage-mode
Date: Sun, 21 Dec 2008 20:56:40 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>,
       SCSI development list <linux-scsi@vger.kernel.org>
References: <Pine.LNX.4.44L0.0812202200010.513-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812202200010.513-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812212056.40950.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of December 2008, Alan Stern wrote:
> On Sat, 20 Dec 2008, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12099
> > Subject		: Nokia 5310 storage-mode
> > Submitter	: Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>
> > Date		: 2008-11-25 01:07 (26 days old)
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > Patch		: http://marc.info/?l=linux-kernel&m=122762731503933&w=4
> 
> This has been fixed by commit a4b188095912eee83d065f000dfe06f25919750b.

Thanks for the update and for closing the bug.

Rafael
