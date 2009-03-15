Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZCOFCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZCOFCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZCOFCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 01:02:12 -0400
Received: from kroah.org ([198.145.64.141]:58835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874AbZCOFCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 01:02:11 -0400
Date: Sat, 14 Mar 2009 22:01:00 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #12871] usb bluetooth crashes system
Message-ID: <20090315050100.GA9456@kroah.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.cVC.K4BvJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GCLaknAim2M.A.cVC.K4BvJB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 08:05:39PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12871
> Subject		: usb bluetooth crashes system
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2009-03-10 11:23 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=123668450400940&w=4

I think we need some more information here.

Pavel?
