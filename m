Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYBERFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYBERFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYBERFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:05:43 -0500
Received: from mga10.intel.com ([192.55.52.92]:12132 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753546AbYBERFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:05:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,308,1199692800"; 
   d="scan'208";a="296012950"
Message-ID: <47A89664.8020407@linux.intel.com>
Date: Tue, 05 Feb 2008 09:01:24 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <10779.1202230436@turing-police.cc.vt.edu>
In-Reply-To: <10779.1202230436@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Sun, 03 Feb 2008 17:16:34 PST, Andrew Morton said:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> 
> Builds, boots, mostly seems to run for limited testing.
> 
> One note - the following commit(s) (and related CPA reworking) broke the NVidia
> binary driver (which is OK, I can fix *that* part).  But can somebody explain
> if this should have seen a trip through the -mm tree before it hit mainstream?
> I didn't see these in 24-rc8-mm1:

well that depends on which -mm you tried; I'm sure the mm kernel of the day had it for a while.
I don't think it's a realistic expectation to delay every bugfix and arch patch until Andrew
gets around to releasing an -mm, not do I see the point of that, what would have been different?
