Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbZAHX7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbZAHX7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZAHX7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:59:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZAHX7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:59:14 -0500
Message-ID: <4966925C.2040702@zytor.com>
Date: Thu, 08 Jan 2009 15:55:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org>
In-Reply-To: <20090108165029.GA10951@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>>
>> Squashfs is a compressed read-only filesystem. It compresses metadata
>> and data, and uses up to 1 MiB block sizes for greater compression.
> 
> That seems pretty fast for something only posted this week and not
> even in -next.
> 

It is in -next, but, to be fair, it has trivial impact on the rest of
the system, which should also be considered.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

