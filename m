Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXI0Tll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXI0Tll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbXI0Tld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:41:33 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:32185 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771AbXI0Tld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:41:33 -0400
From: Frans Pop <elendil@planet.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] Hook up group scheduler with control groups
Date: Thu, 27 Sep 2007 21:41:26 +0200
User-Agent: KMail/1.9.7
Cc: vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, dmitry.adamushko@gmail.com, efault@gmx.de,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709272141.28571.elendil@planet.nl>
X-OriginalArrivalTime: 27 Sep 2007 19:41:30.0792 (UTC) FILETIME=[67032A80:01C8013E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> +config FAIR_CGROUP_SCHED
> +	bool "Control groups"
> + 	depends on CGROUPS
> + 	help

There are also stray spaces before the tab on the last two lines above.

Cheers,
Frans Pop
