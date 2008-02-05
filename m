Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYBETv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYBETv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYBETvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:51:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:17481 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbYBETvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:51:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,308,1199692800"; 
   d="scan'208";a="335386544"
Message-ID: <47A8BDF3.6080609@linux.intel.com>
Date: Tue, 05 Feb 2008 11:50:11 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <10779.1202230436@turing-police.cc.vt.edu>            <47A89664.8020407@linux.intel.com> <3289.1202240894@turing-police.cc.vt.edu>
In-Reply-To: <3289.1202240894@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
>> I don't think it's a realistic expectation to delay every bugfix and arch patch until Andrew
>> gets around to releasing an -mm, not do I see the point of that, what would have been different?
> 
> A bugfix?

yes it was a really painful bugfix, but still.

I'll repeat the question. What would waiting for an -mm release have bought for this bugfix?
Answer: nothing more than what was done on Linus git.
