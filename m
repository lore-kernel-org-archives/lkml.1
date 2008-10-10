Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbYJJQ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbYJJQ3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYJJQ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:29:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54710
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759423AbYJJQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:29:38 -0400
Date: Fri, 10 Oct 2008 09:29:14 -0700 (PDT)
Message-Id: <20081010.092914.162463888.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com
Subject: Re: [GIT PULL] block changes for 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081010080916.GV19428@kernel.dk>
References: <20081010080916.GV19428@kernel.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 10 Oct 2008 10:09:16 +0200

> This is the bulk of the block layer changes for 2.6.28. As other git
> trees are based on this (like SCSI), it would be good if you could merge
> it sooner rather than later.
> 
> Please pull from:
> 
>         git://git.kernel.dk/linux-2.6-block.git for-2.6.28

Did you merge in my generic remote softirq bits or are you going
to do that later?
