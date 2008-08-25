Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYHYKYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYHYKYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYHYKYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:24:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:37656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbYHYKYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:24:34 -0400
Message-ID: <48B2881B.2050903@suse.de>
Date: Mon, 25 Aug 2008 12:23:23 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Abdel Benamrouche <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 1/3 blk-for-2.6.28] block: misc fixes and improvements
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset contains the following five patches containing misc
> fixes and improvements.
> 
>   0001-block-fix-partition-info-printouts.patch
>   0002-block-don-t-grab-block_class_lock-unnecessarily.patch
>   0003-block-use-class_dev_iterator-instead-of-class_for_e.patch
>   0004-block-allow-deleting-zero-length-partition.patch
>   0005-block-update-add_partition-error-handling.patch

Oops, forgot to pass -n to git-format-patch.  The above order is correct
and the git tree has it all ordered, so I won't resend to the mailing
list.  Jens, I'll resend with proper numbers to you privately.

Thanks.

-- 
tejun
