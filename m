Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZJAWtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZJAWtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZJAWtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:49:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:43598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZJAWs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:48:59 -0400
Subject: Re: 2.6.32-rc1-git2: Reported regressions from 2.6.31
From: James Bottomley <James.Bottomley@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 17:48:56 -0500
Message-Id: <1254437336.3885.68.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 21:26 +0200, Rafael J. Wysocki wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14214
> Subject         : BUG at drivers/scsi/scsi_lib.c:1108!
> Submitter       : Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
> Date            : 2009-09-23 11:13 (9 days old)

This one is fixed (as confirmed by the bug report).

James


