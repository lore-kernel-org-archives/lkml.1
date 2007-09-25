Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXIYKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXIYKki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXIYKka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:40:30 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58472 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXIYKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:40:29 -0400
Message-ID: <46F8E563.8030105@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 16:09:31 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/

Hi Andrew,

The build error reported at http://lkml.org/lkml/2007/9/20/210 for the
drivers/ata/pata_scc.c is seen in both 2.6.23-rc7-mm1 and 2.6.23-rc8-mm1.

The patch proposed for this build error at http://lkml.org/lkml/2007/9/21/557
is not seen in the latest 2.6.23-rc8-mm1 patch's.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
