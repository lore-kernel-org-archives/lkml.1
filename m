Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZL2VGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZL2VGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZL2VGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:06:09 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:50605 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZL2VGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:06:07 -0500
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 16:06:06 EST
Message-ID: <4B3A6CB1.3030305@freemail.hu>
Date: Tue, 29 Dec 2009 21:55:13 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <4B3A5BC2.10207@gmail.com>
In-Reply-To: <4B3A5BC2.10207@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=13
	Fuz1=13 Fuz2=13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> Rafael J. Wysocki wrote, On 12/29/2009 04:26 PM:
> 
> ...
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
>> Subject		: IP address assigned by DHCP is dropped after ~40 seconds
>> Submitter	: Márton Németh <nm127@freemail.hu>
>> Date		: 2009-12-13 08:59 (17 days old)
>>
> 
> 
> IMHO this bug might be considered as fixed by updating a userspace tool
> (KNetworkManager) - unless somebody wants to seek for the exact reason...

For me (I am the reporter) the problem was solved by upgrading a userspace
tool, so I think the bug filed against the kernel can be closed marking
that this was not really a kernel bug.

Regards,

	Márton Németh


