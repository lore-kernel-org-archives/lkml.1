Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXCNMM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXCNMM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161186AbXCNMM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:12:59 -0400
Received: from xenotime.net ([66.160.160.81]:35756 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161187AbXCNMM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:12:59 -0400
Date: Wed, 14 Mar 2007 05:12:57 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: jlan@sgi.com, balbir@in.ibm.com
cc: linux-kernel@vger.kernel.org
Subject: taskstats accounting info
Message-ID: <Pine.LNX.4.58.0703140503250.28169@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Documentation/accounting/delay-accounting.txt says that the
getdelays program has a "-c cmd" argument, but that option
does not seem to exist in Documentation/account/getdelays.c.

Do you have an updated version of getdelays.c?
If not, please correct that documentation.

Is getdelays.c the best available example of a program
using the taskstats netlink interface?

Thanks,
-- 
~Randy

PS:  Please add your email info to MAINTAINERS or CREDITS or
kernel/*.c so that people don't have to search email archives
in order to be able to contact you.
