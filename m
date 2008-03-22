Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYCVCwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYCVCwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYCVCwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:52:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50276 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbYCVCwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:52:18 -0400
Message-ID: <47E4745D.3090902@garzik.org>
Date: Fri, 21 Mar 2008 22:52:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Su, Henry" <Henry.Su@amd.com>, "Cai, Crane" <Crane.Cai@amd.com>,
       Shane Huang <Shane.Huang@amd.com>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
References: <200803220259.48534.rjw@sisk.pl>
In-Reply-To: <200803220259.48534.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Unresolved regressions
> ----------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9412
> Subject		: Since commit 'x86: enable iommu_merge by default' (948062683004d13ca21c8c05ac052d387978a449) 2.6 is no go on SB600 AHCI
> Submitter	: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
> Date		: 2007-11-19 14:43 (124 days old)


This one seems to imply that the workaround approved by AMD/ATI didn't 
work...

(AMD folks CC'd...)

	Jeff


