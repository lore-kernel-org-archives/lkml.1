Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbYBHGuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbYBHGuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 01:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBHGt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 01:49:58 -0500
Received: from smtp.nokia.com ([192.100.122.233]:20778 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYBHGt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 01:49:57 -0500
Message-ID: <47ABFB0A.7040405@nokia.com>
Date: Fri, 08 Feb 2008 08:47:38 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBI: add mtd_num sysfs attribute
References: <200802071907.m17J7eYA022058@hera.kernel.org> <20080208054743.GA13097@kroah.com>
In-Reply-To: <20080208054743.GA13097@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Feb 2008 06:49:17.0290 (UTC) FILETIME=[B97254A0:01C86A1E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 07, 2008 at 07:07:40PM +0000, Linux Kernel Mailing List wrote:
>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b6b76ba466bbd47397efad0fdaeaa5ebf7d462c7
>> Commit:     b6b76ba466bbd47397efad0fdaeaa5ebf7d462c7
>> Parent:     d1f3dd6cc00f5bf744118fb2820ecdf09a1f4b73
>> Author:     Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> AuthorDate: Wed Dec 26 13:46:46 2007 +0200
>> Committer:  Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> CommitDate: Wed Dec 26 19:15:17 2007 +0200
>>
>>     UBI: add mtd_num sysfs attribute
>>     
>>     Expose number or the underlying MTD device in sysfs.
> 
> Can you please add this information to Documentation/ABI/ so that people
> know what is going on here?

Sure, will do.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
