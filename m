Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYAXWR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYAXWR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYAXWRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:17:49 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35966 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYAXWRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:17:48 -0500
Subject: Re: [patch 19/26] mount options: fix jfs
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080124135713.76523ba6.akpm@linux-foundation.org>
References: <20080124193341.166753833@szeredi.hu>
	 <20080124193445.807705054@szeredi.hu>
	 <1201209301.32767.4.camel@norville.austin.ibm.com>
	 <20080124135713.76523ba6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 16:17:36 -0600
Message-Id: <1201213056.32767.13.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 13:57 -0800, Andrew Morton wrote:

> My usual algorithm here is to
> 
> 1: queue all the patches and send the ones which have a maintainer to
>    that maintainer until he merges it.
> 
> 2: If the patches have a dependency upon (say) a VFS patch then I'll
>    merge the VFS patch and will then goto 1.
> 
> I don't think this particular patch has a VFS depencency so sure, merge
> away.  You'll probably see that I merged it anyway, but I'll drop it again
> when I see it turn up in your tree (I used to resync with the git trees
> at least daily, but I now do this far less frequently because it is such
> torture because everyone is paddling in everyone else's puddle).

Merged.  Thanks.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

