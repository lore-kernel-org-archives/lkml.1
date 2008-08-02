Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYHBQcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYHBQcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 12:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYHBQcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 12:32:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61473 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYHBQcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:32:41 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5352"; a="5266703"
Message-ID: <48948C3A.6050805@qualcomm.com>
Date: Sat, 02 Aug 2008 09:32:58 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com> <20080802063900.6615e5ca.pj@sgi.com>
In-Reply-To: <20080802063900.6615e5ca.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> The Subject line suggests that this latest version of your patch should
> apply on top of 2.6.27-rc1.  That does not seem to be quite accurate.
> 
> As stated in your previous message, it seems you're working on top of
> Linus's latest git version, which, at least for the source file
> kernel/cpuset.c, is (I suppose) more or less the same as 2.6.27-rc1
> plus the 'origin.patch' that is at the top of Andrew's broken out quilt
> patch series 2.6.27-rc1-mm1.
> 
> That origin.patch includes Li Zefan's patch:
> 
>   cpuset: clean up cpuset hierarchy traversal code
> 
> which Andrew recently sent along to Linus, and which patch is presumed
> by this latest version of your patch.
> 
> I'll take a further look at your patch now.
> 
> We have lots of trees, including various from Ingo, linux-next, Andrew,
> and Linus, each in many versions.  It helps others if you can state
> exactly what tree/version a patch applies to, in each patch version
> that you submit.

It's on top of the latest mainline I should not have put -rc1 in the subject
sorry.

Max


