Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYGOMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYGOMlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbYGOMlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:41:12 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:19685 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbYGOMlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:41:11 -0400
Message-Id: <487C63AD.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 15 Jul 2008 06:45:33 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <torvalds@linux-foundation.org>, "Max Krasnyansky" <maxk@qualcomm.com>,
       <pj@sgi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and
	redo sched domain managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
In-Reply-To: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

>>> On Tue, Jul 15, 2008 at  7:43 AM, in message
<1216122229-4865-1-git-send-email-maxk@qualcomm.com>, Max Krasnyansky
<maxk@qualcomm.com> wrote: 
> 
> Greg, please take a look at the RT balancer merge. I decided not to muck
> with the cpupri thing and instead mask inactive cpus after the search.

Ill take a look at this later today.

Regards,
-Greg



