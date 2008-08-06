Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbYHFD3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbYHFD3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYHFD3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:29:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36883 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752037AbYHFD33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:29:29 -0400
Date: Tue, 5 Aug 2008 22:29:27 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080805222927.6dd95f5f.pj@sgi.com>
In-Reply-To: <48991973.90109@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
	<20080804010033.0d1b0549.pj@sgi.com>
	<48977E81.4040207@qualcomm.com>
	<20080804225636.541527e8.pj@sgi.com>
	<4898B873.6000308@qualcomm.com>
	<20080805180521.be7010e1.pj@sgi.com>
	<48991973.90109@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> But it does seem like an overkill to schedule a workqueue ...

"overkill" -- by what metric?

If something is overkill, it means something is excessive.
Excess (and deficiency) occur along some scale, some metric.

If not by CPU cycles, then by what metric is it overkill?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
