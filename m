Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbZAHRFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbZAHRFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZAHRFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:05:17 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:38613 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZAHRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:05:16 -0500
Message-ID: <4966324A.6070900@lougher.demon.co.uk>
Date: Thu, 08 Jan 2009 17:05:14 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org>
In-Reply-To: <20090108165029.GA10951@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
>> Please consider pulling my linux-next branch
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
>>
>> The patches have been posted to LKML and linux-fsdevel over the last
>> couple of months and have been reviewed and changed as requested.
>> Diffstat below.
>>
>> Squashfs is a compressed read-only filesystem. It compresses metadata
>> and data, and uses up to 1 MiB block sizes for greater compression.
> 
> That seems pretty fast for something only posted this week and not
> even in -next.
> 
> 

It is in -next.  This is the third set of patches incorporating
all the review comments from earlier patches sent since last October.

Phillip

