Return-Path: <linux-kernel-owner+w=401wt.eu-S935285AbXJQF7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285AbXJQF7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763635AbXJQF7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:59:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48083 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXJQF7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:59:14 -0400
Message-ID: <4715A4AE.7050402@garzik.org>
Date: Wed, 17 Oct 2007 01:59:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
CC: Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: [PATCH 0/6] forcedeth interrupt and task overhaul, v2
References: <20071017055251.GA19972@havoc.gtf.org>
In-Reply-To: <20071017055251.GA19972@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> These six changes can be found in the 'fe' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

Note the change from the previous 'fe-lock' branch, which is now left 
as-is on kernel.org, but not being updated.


