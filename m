Return-Path: <linux-kernel-owner+w=401wt.eu-S935783AbXGZStz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783AbXGZStz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762498AbXGZSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:49:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758602AbXGZStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:49:25 -0400
Date: Thu, 26 Jul 2007 11:49:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] I/OAT: Add support for DCA - Direct Cache Access
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C02C1F61B@orsmsx418.amr.corp.intel.com>
Message-ID: <alpine.LFD.0.999.0707261148140.3442@woody.linux-foundation.org>
References: <BAE9DCEF64577A439B3A37F36F9B691C02C1F61B@orsmsx418.amr.corp.in
 tel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Nelson, Shannon wrote:
> 
> In order to include support for DCA (Direct Cache Access) from IOAT,
> please pull from my git tree at
> 	git://lost.foo-projects.org/~sln/linux-2.6 dma-upstream

No. It's after the merge window, and I'm not interested for 2.6.23. 

Why cannot people learn? If it didn't get into -rc1, it's not in. It 
really is that simple. I shouldn't have to shout at people. 

		Linus
