Return-Path: <linux-kernel-owner+w=401wt.eu-S1765652AbXF1S5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765652AbXF1S5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764917AbXF1S5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:57:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51253 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104AbXF1S5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:57:44 -0400
Message-ID: <468404A0.503@garzik.org>
Date: Thu, 28 Jun 2007 14:57:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>,
       suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
References: <20070510223950.GD86004887@sgi.com>	<20070511110301.GB28425@in.ibm.com>	<20070512080157.GF85884050@sgi.com>	<20070612061652.GA6320@amitarora.in.ibm.com>	<20070613235217.GS86004887@sgi.com>	<20070614091458.GH5181@schatzie.adilger.int>	<20070614120413.GD86004887@sgi.com>	<20070614193347.GN5181@schatzie.adilger.int>	<20070625132810.GA1951@amitarora.in.ibm.com>	<20070628025543.9467216f.akpm@linux-foundation.org>	<20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org>
In-Reply-To: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> b) We do what we normally don't do and reserve the syscall slots in mainline.

If everyone agrees it's going to happen... why not?

	Jeff


