Return-Path: <linux-kernel-owner+w=401wt.eu-S1030653AbXDWD4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653AbXDWD4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030656AbXDWD4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:56:03 -0400
Received: from [70.254.190.220] ([70.254.190.220]:52063 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030653AbXDWD4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:56:03 -0400
Date: Mon, 23 Apr 2007 03:56:00 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Rik van Riel <riel@redhat.com>
cc: Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: <462C2E5B.1080008@redhat.com>
Message-ID: <Pine.LNX.4.64.0704230353000.25153@server.thyself>
References: <20070423020046.GA28477@omnifarious.org> <462C2E5B.1080008@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Eric Hopper wrote:
>>  I know that this whole effort has been put in disarray by the
>>  prosecution of Hans Reiser, but I'm curious as to its status. 
>
> It was in disarray well before.  Many of the reiser4 features,
> like filesystem plugins, make more technical sense in the Linux
> VFS, but made more business sense for Namesys as a reiserfs 4
> thing.  That lead to a stalemate.
>
Shouldn't it be a matter of stability though? Benchmarks suggest that 
reiser4 is a good file system; reiser4 is the successor to the 
already-accepted reiserfs; we've got experimental ext4 support but no 
reiser4 support, etc.

I don't see why something like plugins should matter. If it works enough 
to be marked as experimental, why shouldn't reiser4 support be included?
It's a pain for me personally to have to patch any kernel with reiser4 
support so I can use the reiser4 fs.

William Heimbigner
icxcnika@mar.tar.cc



