Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXKAOB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXKAOB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXKAOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:01:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:57341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbXKAOBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:01:47 -0400
Date: Thu, 1 Nov 2007 15:01:46 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/4] ticket spinlocks for x86
Message-ID: <20071101140146.GA26879@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to propose these patches for the x86 tree for a bit more exposure
and testing. Or at least get some discussion going again.

Just for fun I also had a shot at merging the headers, as they become a
lot more similar after this with the removal of the paravirt crud.


Nick
