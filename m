Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYE3AM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYE3AM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYE3AMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:12:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbYE3AMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:12:17 -0400
Date: Thu, 29 May 2008 19:12:11 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched
 domains (ie remove cpu_isolated_map)
Message-Id: <20080529191211.080ec5cf.pj@sgi.com>
In-Reply-To: <483F3559.1030806@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>
	<20080529173759.ccbaf8ef.pj@sgi.com>
	<483F3559.1030806@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> btw I suppose you missed my reply.

I did not see your reply.  Did you send it to me or lkml?

> Also Ingo at some point accepted a patch from Peter
> that partially removed the isolated map.

Reference?  Did it remove the boot parameter isolcpus= ?

My concern is removing user visible features, without
good reason and careful consideration and some planning.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
