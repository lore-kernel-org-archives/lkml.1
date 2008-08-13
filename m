Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYHMIXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYHMIXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYHMIXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:23:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40429 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751487AbYHMIXL (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:23:11 -0400
Message-ID: <48A29B78.4030600@sgi.com>
Date: Wed, 13 Aug 2008 18:29:44 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS update for 2.6.27-rc4
References: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com> <20080813011606.06f2c2da.akpm@linux-foundation.org>
In-Reply-To: <20080813011606.06f2c2da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 Aug 2008 18:11:47 +1000 lachlan@sgi.com (Lachlan McIlroy) wrote:
> 
>> The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
>>   Linus Torvalds (1):
>>         Linux 2.6.27-rc3
>>
>> are available in the git repository at:
>>
>>   git://oss.sgi.com:8090/xfs/linux-2.6 master
> 
> Who do I have to pay to get rid of these:
> 
> xfs-use-get_unaligned_-helpers.patch
> xfs-clean-up-stale-references-to-semaphores.patch
> xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
> xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
> xfs-replace-inode-flush-semaphore-with-a-completion.patch
> xfs-replace-dquot-flush-semaphore-with-a-completion.patch
> xfs-remove-the-sema_t-from-xfs.patch
> 
> and how much?
You can pay me if you like.  All of those mods are in this git pull
request so they will be in mainline soon enough.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
