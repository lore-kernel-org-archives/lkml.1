Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYHMIQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYHMIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYHMIQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:16:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbYHMIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:16:41 -0400
Date: Wed, 13 Aug 2008 01:16:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: lachlan@sgi.com (Lachlan McIlroy)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS update for 2.6.27-rc4
Message-Id: <20080813011606.06f2c2da.akpm@linux-foundation.org>
In-Reply-To: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com>
References: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 18:11:47 +1000 lachlan@sgi.com (Lachlan McIlroy) wrote:

> The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
>   Linus Torvalds (1):
>         Linux 2.6.27-rc3
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com:8090/xfs/linux-2.6 master

Who do I have to pay to get rid of these:

xfs-use-get_unaligned_-helpers.patch
xfs-clean-up-stale-references-to-semaphores.patch
xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
xfs-replace-inode-flush-semaphore-with-a-completion.patch
xfs-replace-dquot-flush-semaphore-with-a-completion.patch
xfs-remove-the-sema_t-from-xfs.patch

and how much?

