Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZCLSDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZCLSDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZCLSCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:02:55 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42946 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZCLSCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:02:55 -0400
Message-ID: <49B94E43.6000405@davidnewall.com>
Date: Fri, 13 Mar 2009 04:32:43 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] (latest tip) make dequeue_task less confusing
References: <49B8CE2B.8070402@davidnewall.com>	 <20090312095518.GB16721@elte.hu> <1236864997.6075.22.camel@marge.simson.net>
In-Reply-To: <1236864997.6075.22.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Is there any real gain from doing this?  It messes up the symmetry of
> enqueue/dequeue.


No.  On further consideration, I don't like my patch.
