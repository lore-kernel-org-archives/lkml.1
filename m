Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZHFPMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZHFPMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbZHFPMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:12:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbZHFPMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:12:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [Bug #13644] hibernation/swsusp lockup due to acpi-cpufreq
Date: Thu, 6 Aug 2009 17:12:31 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <7ixSg7D88bK.A.i2F.UqgdKB@chimera> <20090806144938.GA6817@sig21.net>
In-Reply-To: <20090806144938.GA6817@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061712.31814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Johannes Stezenbach wrote:
> On Sun, Aug 02, 2009 at 09:09:32PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13644
> > Subject		: hibernation/swsusp lockup due to acpi-cpufreq
> > Submitter	: Johannes Stezenbach <js@sig21.net>
> > Date		: 2009-06-16 01:27 (48 days old)
> > References	: http://lkml.org/lkml/2009/6/15/630
> > 		  http://lkml.org/lkml/2009/6/29/504
> > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> 
> This issue is fixed in linux-2.6.31-rc5-246-g90bc1a6,
> I'm guessing due to
> 
>  commit 4bc5d34135039566b8d6efa2de7515b2be505da8
>  Author: Dave Jones <davej@redhat.com>
>  Date:   Tue Aug 4 14:03:25 2009 -0400
> 
>     [CPUFREQ] Make cpufreq suspend code conditional on powerpc.

Thanks, bug closed.

Rafael
