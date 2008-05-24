Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYEXPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYEXPjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYEXPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:39:37 -0400
Received: from sandeen.net ([209.173.210.139]:11130 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbYEXPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:39:36 -0400
Message-ID: <483836B6.8030406@sandeen.net>
Date: Sat, 24 May 2008 10:39:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Greaves <david@dgreaves.com>, Greg KH <greg@kroah.com>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       LinuxRaid <linux-raid@vger.kernel.org>, stable@kernel.org
Subject: Re: RFI for 2.6.25.5 : Re: Regression- XFS won't mount on partitioned
 md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com> <4838192F.3050004@dgreaves.com> <20080524135258.GF6749@1wt.eu>
In-Reply-To: <20080524135258.GF6749@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> It would have helped to CC stable (fixed) and to give the mainline commit
> ID since the stable branch only holds already merged patches. Greg, the
> commit is 6ab455ee...
> 
> Willy

Yup I'll agree that this should probably go to -stable unless hch or
dchinner disagree.

FWIW I've already put it in the Fedora kernels.

-Eric
