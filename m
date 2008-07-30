Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYG3KNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYG3KNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYG3KNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:13:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54430 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752478AbYG3KND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:13:03 -0400
Date: Wed, 30 Jul 2008 05:12:59 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
Message-Id: <20080730051259.834a1c9e.pj@sgi.com>
In-Reply-To: <488DFFD2.7070004@qualcomm.com>
References: <488D332A.1030008@cn.fujitsu.com>
	<20080728010141.fbd33866.pj@sgi.com>
	<488DFFD2.7070004@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Paul, please take a look at
> 	cpuset: Rework sched domains and CPU hotplug handling
> patch I sent out last week.

Ok - I've been trying to get to this for the last two days,
but my good employer has reorganized me twice so far this week ;).

If I can keep the same boss for more than eight hours,
I should find time to get to this today.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
