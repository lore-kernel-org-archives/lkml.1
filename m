Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYKIVGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYKIVGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYKIVGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:06:32 -0500
Received: from mail.fieldses.org ([66.93.2.214]:34928 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbYKIVGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:06:32 -0500
Date: Sun, 9 Nov 2008 16:05:56 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Doug Nazar <nazard@dragoninc.ca>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [Bug #11985] 2.6.28-rc3 truncates nfsd results
Message-ID: <20081109210556.GF27376@fieldses.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <wnN9HICUAgP.A.DUF.W4zFJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wnN9HICUAgP.A.DUF.W4zFJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 06:59:15PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11985
> Subject		: 2.6.28-rc3 truncates nfsd results
> Submitter	: Doug Nazar <nazard@dragoninc.ca>
> Date		: 2008-11-04 18:27 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=122582366509153&w=4
> Handled-By	: Doug Nazar <nazard@dragoninc.ca>
> 		  J. Bruce Fields <bfields@fieldses.org>
> Patch		: http://marc.info/?l=linux-kernel&m=122592648119790&w=4

The above patch has just been submitted to Linus.

--b.
