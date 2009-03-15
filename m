Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZCOLwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZCOLwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZCOLvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:51:53 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40673 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbZCOLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:51:52 -0400
Message-ID: <49BCEBD3.3090206@in.ibm.com>
Date: Sun, 15 Mar 2009 17:21:47 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Bug #12792] 2.6.29-rc6-git4 boot failure
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.RoD.14BvJB@chimera> <49BCBD0E.40401@in.ibm.com> <200903151148.36879.rjw@sisk.pl>
In-Reply-To: <200903151148.36879.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> I can still recreate this with 2.6.29-rc8-git1. Same trace and same
>> point of failure.
>>     
This problem seems to have been introduced somewhere during 2.6.28 git3/git4.
I can boot 2.6.28-git2 successfully on this box. Could not confirm with git3
as it had kernel build failure issues. git4 kernel failed to boot with same
backtrace as reported. 

Will try to further narrow down this issue.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

