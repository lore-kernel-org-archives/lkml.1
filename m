Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbYLZC2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbYLZC2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYLZC14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:27:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:9901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYLZC14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:27:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,283,1228118400"; 
   d="scan'208";a="417497636"
Subject: Re: Happy v2.6.28
From: Zhu Yi <yi.zhu@intel.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Jim Paris <jim@jtan.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <81b0412b0812250640t5d6180dct31d8cd941e06ef50@mail.gmail.com>
References: <alpine.LFD.2.00.0812241540170.3535@localhost.localdomain>
	 <81b0412b0812250640t5d6180dct31d8cd941e06ef50@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 10:27:02 +0800
Message-Id: <1230258422.27521.9.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-25 at 22:40 +0800, Alex Riesen wrote:
> iwl3945 is still broken as described in
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=11326
> 
> It is actually quite annoying, as it prevents shutdown when crashed.
> The bug discussion mentions a fix (which looks like a workaround,
> because there is still a scary message in the log). But at least
> the system can be safely shut down.

The patch should be a valid fix for the symptom. But we haven't find the
root cause yet. Will submit the patch to wireless-testing.

Thanks,
-yi

