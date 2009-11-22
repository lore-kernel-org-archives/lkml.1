Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZKVO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZKVO7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 09:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZKVO7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 09:59:47 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:43499 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZKVO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 09:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tuKEkMPvyQ44KzQTLUFL3Yrr4u9FAjpZk3V5NazX/hddTJLOySXlExvSAwPGuRZ0Zy
         L6RyPWxZV8tTLshQe9YiQOPCMpWFSKLSg6xkh0pgqWfjyZFAGPZg+V0pi9fcraG60unJ
         W5ybXm8zAn/8YXsLYARN4X7bxJJBWFIEC9osg=
Message-ID: <4B095219.2040708@gmail.com>
Date: Sun, 22 Nov 2009 07:00:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer
 to expected String
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera> <l2_yP_tdgYK.A.v5D.R8_BLB@chimera>
In-Reply-To: <l2_yP_tdgYK.A.v5D.R8_BLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
> Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2009-10-08 21:46 (45 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
> References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
> Handled-By	: Alexey Starikovskiy<astarikovskiy@suse.de>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347
>
>
>
>    
still there.

Justin P. Mattock
