Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYLUDIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYLUDIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 22:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYLUDHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 22:07:55 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1570 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751084AbYLUDHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 22:07:54 -0500
Date: Sat, 20 Dec 2008 22:07:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Bug #12099] Nokia 5310 storage-mode
In-Reply-To: <CMMRhk39O-L.A.xbC.XkYTJB@chimera>
Message-ID: <Pine.LNX.4.44L0.0812202200010.513-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12099
> Subject		: Nokia 5310 storage-mode
> Submitter	: Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>
> Date		: 2008-11-25 01:07 (26 days old)
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://marc.info/?l=linux-kernel&m=122762731503933&w=4

This has been fixed by commit a4b188095912eee83d065f000dfe06f25919750b.

Alan Stern

