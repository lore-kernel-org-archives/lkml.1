Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZGOHml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZGOHml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZGOHml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:42:41 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:42495 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZGOHmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:42:40 -0400
Message-ID: <4A5D886E.4070707@turknet.net.tr>
Date: Wed, 15 Jul 2009 10:42:38 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1pre) Gecko/20090714 Shredder/3.0b3pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13657] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.iLF.m0oUKB@chimera>
In-Reply-To: <dWkuWjWDsSB.A.iLF.m0oUKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2009 07:42:39.0336 (UTC) FILETIME=[D40F0680:01CA051F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 03:00 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13657
> Subject		: Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
> Submitter	: Tarkan Erimer<tarkan.erimer@turknet.net.tr>
> Date		: 2009-06-26 10:03 (11 days old)
> References	: http://lkml.org/lkml/2009/6/26/34
>
>
>    

I confirm that, as of Linux-2.6.31-rc3, this bug still exists.
