Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYA1TOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYA1TOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbYA1TKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:10:23 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50659 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755921AbYA1TKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:10:21 -0500
Date: Mon, 28 Jan 2008 13:10:17 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: [CPUISOL] CPU isolation extensions
Message-Id: <20080128131017.5219acc8.pj@sgi.com>
In-Reply-To: <479E1FD4.5040606@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	<1201511305.6149.30.camel@lappy>
	<479E1FD4.5040606@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Also "CPU sets" seem to mostly deal with the scheduler domains.

True - though "cpusets" (no space ;) sched_load_balance flag can
be used to see that some CPUs are not in any scheduler domain,
which is equivalent to not having the scheduler run on them.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
