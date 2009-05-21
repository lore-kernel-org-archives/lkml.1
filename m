Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZEUNWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZEUNWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZEUNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:21:57 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:37298 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEUNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:21:57 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A155573.9010606@lwfinger.net>
Date: Thu, 21 May 2009 08:21:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.SU.iYzDKB@chimera>
In-Reply-To: <385Pu-agh7M.A.SU.iYzDKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject		: Page allocation failures with b43 and p54usb
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-04-29 21:01 (18 days old)
> References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>

I have been unable to repeat the problem with recent kernels - I am now running
2.6.30-rc6. This regression should probably be dropped even though it may show
up when 2.6.30 is released.

Larry
