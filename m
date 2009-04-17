Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZDQAyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZDQAyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbZDQAyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:54:11 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:50095 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbZDQAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:54:10 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49E7D320.3080900@lwfinger.net>
Date: Thu, 16 Apr 2009 19:53:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "2.6.30-rc1: intel 3945 no wireless"@ogre.sisk.pl
Subject: Re: [Bug #13106] 2.6.30-rc1: intel 3945 no wireless
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.sp.Zw85JB@chimera>
In-Reply-To: <nY3-4PrO6XH.A.sp.Zw85JB@chimera>
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13106
> Subject		: 2.6.30-rc1: intel 3945 no wireless
> Submitter	: 2.6.30-rc1: intel 3945 no wireless
> Date		: 2009-04-08 5:36 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=123916905605534&w=4

That regression was fixed by Herbert Xu's commit 97c18e2c. It should no longer
be listed.

Larry
