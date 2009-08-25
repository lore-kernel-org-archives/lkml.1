Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbZHYX0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbZHYX0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932346AbZHYX0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:26:24 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:37208 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbZHYX0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=c3+De70XT90ytBK3Zqkx8AxTMUzxb3CrsssQV0EBo/bLb/js8V3xiUqTF8F+ojk8rF
         aCh9Vf/4f8ttu3y7J5yr6dmlFpiHKrDnHqKFipqTCMftLeeZ4ibk9TdslJ/HZyl63ZvK
         OqOgUWSYqJI0yYpd2x1VFtYx2C5iQ4Tf8M40I=
Message-ID: <4A9472CC.2020508@lwfinger.net>
Date: Tue, 25 Aug 2009 18:25:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: 2.6.31-rc6-git5: Reported regressions from 2.6.30
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <4A8F12CE.9090601@lwfinger.net> <200908220002.03707.rjw@sisk.pl>
In-Reply-To: <200908220002.03707.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday 21 August 2009, Larry Finger wrote:
>> Rafael J. Wysocki wrote:
>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13960
>>> Subject		: rtl8187 not connect to wifi
>>> Submitter	: okias <d.okias@gmail.com>
>>> Date		: 2009-08-10 19:16 (10 days old)
>> The patch for this one was sent from Linville to DaveM earlier today,
>> and should be sent to mainline in the near future.
>>
>> AFAIK, the OP has not yet tested the patch, but I think I was able to
>> reproduce the problem, and the patch did fit it for me.
> 
> Thanks for the update.
> 
> Can you please close the bug when the patch is merged?

The patch hit mainline as commit
1a9937b7f07ab6e35515e32a7625f0ba50ab7670. The bug has been closed.

Larry
