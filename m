Return-Path: <linux-kernel-owner+w=401wt.eu-S933731AbXHJInU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbXHJInU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbXHJIm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:42:59 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:55915 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbXHJIm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:42:57 -0400
Date: Fri, 10 Aug 2007 02:43:00 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Coly Li <coyli@suse.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] obsolete fragment from ext4
Message-ID: <20070810084300.GM6689@schatzie.adilger.int>
Mail-Followup-To: Coly Li <coyli@suse.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <46BBD6D7.3050402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BBD6D7.3050402@suse.de>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 10, 2007  11:09 +0800, Coly Li wrote:
> Once ext4 will not implement fragment, it is believed it will never be
> implement in future. Therefore fragment related source code in ext4
> should be obsoleted -- no one will use it.
> 
> This patch obsolete fragment from ext4.
> Another patch posted on linux-ext4 removing fragment supporting from e2fsprogs.
> I tested both patch.
> 
> 
> Signed-Off-By: Coly Li <coyli@suse.de>

Acked-by: Andreas Dilger <adilger@clusterfs.com>

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

