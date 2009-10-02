Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZJBRdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZJBRdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbZJBRdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:33:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35801 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965AbZJBRdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:33:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: 2.6.32-rc1-git2: Reported regressions from 2.6.31
Date: Fri, 2 Oct 2009 19:34:40 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera> <1254437336.3885.68.camel@mulgrave.site>
In-Reply-To: <1254437336.3885.68.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021934.40289.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, James Bottomley wrote:
> On Thu, 2009-10-01 at 21:26 +0200, Rafael J. Wysocki wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14214
> > Subject         : BUG at drivers/scsi/scsi_lib.c:1108!
> > Submitter       : Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
> > Date            : 2009-09-23 11:13 (9 days old)
> 
> This one is fixed (as confirmed by the bug report).

Thanks, closed.

Rafael
