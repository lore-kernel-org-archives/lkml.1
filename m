Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYGaUOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYGaUOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYGaUOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:14:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754330AbYGaUOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:14:23 -0400
Date: Thu, 31 Jul 2008 15:14:21 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, maxk@qualcomm.com,
       menage@google.com, a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
Message-Id: <20080731151421.bb4af984.pj@sgi.com>
In-Reply-To: <1216852381-23445-1-git-send-email-maxk@qualcomm.com>
References: <1216852381-23445-1-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

What kernel version was this patch against?

I've tried 2.6.27-rc1-mm1, 2.6.27-rc1, and 2.6.26,
and it doesn't apply cleanly on any of them.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
