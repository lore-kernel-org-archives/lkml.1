Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZL2VtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZL2VtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZL2VtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:49:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZL2VtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:49:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
Date: Tue, 29 Dec 2009 22:49:48 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       =?utf-8?q?M=C3=A1rton_N=C3=A9meth?= <nm127@freemail.hu>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <4B3A5BC2.10207@gmail.com>
In-Reply-To: <4B3A5BC2.10207@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912292249.48496.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Jarek Poplawski wrote:
> Rafael J. Wysocki wrote, On 12/29/2009 04:26 PM:
> 
> ...
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
> > Subject		: IP address assigned by DHCP is dropped after ~40 seconds
> > Submitter	: Márton Németh <nm127@freemail.hu>
> > Date		: 2009-12-13 08:59 (17 days old)
> > 
> 
> 
> IMHO this bug might be considered as fixed by updating a userspace tool
> (KNetworkManager) - unless somebody wants to seek for the exact reason...

Good, I'll gladly close it. :-)

Rafael
