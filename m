Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbXKFSEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbXKFSEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXKFSEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:04:32 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:60556 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXKFSEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:04:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=VRXpK2L3xcJMl9pSsVRrEZTjG/5lGbHdpgwnSVZGJH++jWxFG/8G2N/ixX4IRZ4x0HrM8YQ9DsBBJx0VCHqHVYu7w5CIQUxhgtmUQ7Kq+kEIlqSK4jTeGC3fRIn9zTTjKXuskFNchblbCDkjbaczmeKOvz6fbM37ToAik2ASn4E=;
Message-ID: <4730AC7D.4000204@unsolicited.net>
Date: Tue, 06 Nov 2007 18:03:41 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
References: <472F5F8B.7090200@unsolicited.net> <394336012.27271@ustc.edu.cn>
In-Reply-To: <394336012.27271@ustc.edu.cn>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu wrote:
> On Mon, Nov 05, 2007 at 06:23:07PM +0000, David wrote:
>   
>> I've attached the output of Sysrq-T to this mail... system is a
>> dual-core AMD64, and files are on a RAID-1 root partition connected two
>> SATA disks on the on-board NVidia controller. I've had no problems
>> before .24 rc1
>>     
>
> Could you try with the attached 4 patches? Two of them are expected to
> fix your problem, another two are debugging ones(in case the problem
> persists).
>
>   
I've applied the patches, and have tried a few reboots with no problems
so far. I will report back if I see any further problems.

Thanks
David
