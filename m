Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZAIVbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZAIVbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZAIVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:31:08 -0500
Received: from mail.lang.hm ([64.81.33.126]:42710 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbZAIVbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:31:05 -0500
Date: Fri, 9 Jan 2009 14:33:08 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Partially defer some of the async stuff to the next release
In-Reply-To: <20090109212201.780c52d0@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0901091432270.3525@asgard.lang.hm>
References: <20090109070910.233e5f3c@infradead.org> <alpine.LFD.2.00.0901091241470.6528@localhost.localdomain> <20090109212201.780c52d0@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Alan Cox wrote:

>> Can we rather make this something that people can enable with a "fastboot"
>> option and is disabled by default? At least that way the ATA people can
>> see the problem, and don't just forget about it, since we want it fixed.
>
> Makes some sense - although the inode one should just take a hike at this
> point. Can the fastboot option live under staging perhaps - its analogous
> to staging drivers although clearly the code doesn't go there in this
> case ?
>
> The trouble otherwise is "fast boot" sounds like something good for
> people to turn on, but right now it's the reverse.

isn't this like OPTIMIZE_INLINE?

David Lang
