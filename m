Return-Path: <linux-kernel-owner+w=401wt.eu-S1422840AbYHFU5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422840AbYHFU5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYHFU4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:56:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752538AbYHFU43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:56:29 -0400
Date: Wed, 6 Aug 2008 15:56:25 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080806155625.a89071b4.pj@sgi.com>
In-Reply-To: <6599ad830808061330j41f2141fva8395239726f5f7f@mail.gmail.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080805180521.be7010e1.pj@sgi.com>
	<48991973.90109@qualcomm.com>
	<20080805222927.6dd95f5f.pj@sgi.com>
	<4899202B.6030303@qualcomm.com>
	<20080805232856.78dd50f7.pj@sgi.com>
	<489930B5.9030906@qualcomm.com>
	<20080806004629.d321f3b0.pj@sgi.com>
	<489A079E.5040903@qualcomm.com>
	<20080806152910.9e4f76a2.pj@sgi.com>
	<6599ad830808061330j41f2141fva8395239726f5f7f@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I'd vote in favour of Max's suggestion of just
> rebuild_sched_domains(), to localize the changes better.

I'm outvoted, two to one.

Go for it, Max.

Thank, Paul M.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
