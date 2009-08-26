Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZHZLyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZHZLyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbZHZLyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:54:02 -0400
Received: from yohan.staff.proxad.net ([213.228.1.71]:51821 "EHLO
	yohan.staff.proxad.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZHZLyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:54:01 -0400
Message-ID: <4A952256.2030602@yohan.staff.proxad.net>
Date: Wed, 26 Aug 2009 13:53:58 +0200
From: Yohan <kernel@yohan.staff.proxad.net>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: VM issue causing high CPU loads
References: <4A92A25A.4050608@yohan.staff.proxad.net> <20090824162155.ce323f08.akpm@linux-foundation.org>
In-Reply-To: <20090824162155.ce323f08.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 24 Aug 2009 16:23:22 +0200
> Yohan <kernel@yohan.staff.proxad.net> wrote:
>   
>> Hi,
>>
>>     Is someone have an idea for that :
>>
>>         http://bugzilla.kernel.org/show_bug.cgi?id=14024
>>     
> Please generate a kernel profile to work out where all the CPU tie is
> being spent.  Documentation/basic_profiling.txt is a starting point.
I did & post the profiles on the bugtrack
I dit it with a 2.6.31-rc7-git2 kernel
(need at least 2 week days after a reboot/drop_cache  to really show the 
bug)

Thanks
