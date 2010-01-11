Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318Ab0AKO6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0AKO6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379Ab0AKO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:58:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58438 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753108Ab0AKO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:58:33 -0500
Date: Mon, 11 Jan 2010 09:58:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [Bug #14896] REGRESSION for RT2561/RT61 in 2.6.32, related to
 power saving
In-Reply-To: <CXIfLt-ygXM.A.1GC.1glSLB@chimera>
Message-ID: <Pine.LNX.4.44L0.1001110957440.2873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14896
> Subject		: REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
> Submitter	: Alan Stern <stern@rowland.harvard.edu>
> Date		: 2009-12-06 22:12 (36 days old)
> References	: http://marc.info/?l=linux-kernel&m=126013756829691&w=4
> Handled-By	: Gertjan van Wingerde <gwingerde@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/67338/

This has been fixed by commit 93b6bd26b74efe46b4579592560f9f1cb7b61994.

Alan Stern

