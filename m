Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYGMT27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYGMT27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYGMT2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:28:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2406 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754644AbYGMT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:28:49 -0400
Date: Sun, 13 Jul 2008 15:28:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #10725] USB Mass storage mount fails: Write protect on
In-Reply-To: <c6ZRbn0adb.A.BVB.VKleIB@albercik>
Message-ID: <Pine.LNX.4.44L0.0807131528180.4671-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
> Subject		: USB Mass storage mount fails: Write protect on
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2008-05-16 14:55 (59 days old)
> References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://marc.info/?l=linux-scsi&m=121433068314568&w=2

This can be removed.  It was fixed by commit 
bdb2b8cab4392ce41ddfbd6773a3da3334daf836.

Alan Stern

