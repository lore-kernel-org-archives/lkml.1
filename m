Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYJXLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYJXLrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYJXLrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:47:24 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36218 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYJXLrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:47:23 -0400
Message-ID: <4901B5C2.9070108@linux.vnet.ibm.com>
Date: Fri, 24 Oct 2008 17:17:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dong-Jae Kang <baramsori72@gmail.com>
CC: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, corsetproject@googlegroups.com,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [Question] power management related with cgroup based resource
 management
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
In-Reply-To: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong-Jae Kang wrote:
> Hi, all
> 
> These days, I am interested in green IT area for low power OS
> So, I have a question about it.
> Is there any good idea or comments about power management related with
> cgroup based resource management?
> I have no idea about that, but it seems to be possible to find a good concept.
> And I hope so
> Is it some strange question? ^^

lesswatts.org, linux-pm (mailing list) are good sources on Power Management. I
would recommend asking at those mailing lists (there are several new features
like range timers, no idle hertz, sched_mc consolidation and much more). Could
you be specific about what you are looking for? Are you looking at
Server/Desktop power management?

-- 
	Balbir
