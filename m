Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbZHUVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbZHUVea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933060AbZHUVeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:34:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:7492 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbZHUVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h/LgIrEHOXPWGtf/H2nONWyORpGbmCO+Cdt2eMCiuy9mZXs7Yc3CtpuWYbSif4aZwo
         YW8s2hXG+VctyQx4FFAl8dHcsRgsydnWchPgdFtXk8jfz/qgZnZONN1yT2ECOnvv9rQK
         nZWHeFygasC6xk0U5PouD3NeRpmP3u3SGzhS0=
Message-ID: <4A8F12CE.9090601@lwfinger.net>
Date: Fri, 21 Aug 2009 16:34:06 -0500
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
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
In-Reply-To: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13960
> Subject		: rtl8187 not connect to wifi
> Submitter	: okias <d.okias@gmail.com>
> Date		: 2009-08-10 19:16 (10 days old)

The patch for this one was sent from Linville to DaveM earlier today,
and should be sent to mainline in the near future.

AFAIK, the OP has not yet tested the patch, but I think I was able to
reproduce the problem, and the patch did fit it for me.

Larry
