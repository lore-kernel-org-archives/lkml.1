Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYGJPDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYGJPDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbYGJPDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:03:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44403 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYGJPDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:03:31 -0400
Date: Thu, 10 Jul 2008 13:34:08 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH -mm 1/8] PM: Add new PM_EVENT codes for runtime power
	transitions
Message-ID: <20080710113408.GA15412@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100155.34153.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100155.34153.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-10 01:55:33, Rafael J. Wysocki wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> Subject: PM: Add new PM_EVENT codes for runtime power transitions
> 
> This patch (as1112) adds some new PM_EVENT_* codes for use by kernel
> subsystems.  They describe runtime power-state transitions of the sort
> already implemented by the USB subsystem.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
