Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbZCYRJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbZCYRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZCYRJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:09:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760843AbZCYRJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:09:48 -0400
Message-ID: <49CA6692.9060807@suse.de>
Date: Thu, 26 Mar 2009 01:14:58 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30 -mm merge plans
References: <20090323224615.cd29edfd.akpm@linux-foundation.org>
In-Reply-To: <20090323224615.cd29edfd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton Wrote:
>  Might merge.  Need to revisit this.
Thanks for the revisit, I will feedback ASAP.

> 
>     fs-adfs-return-f_fsid-for-statfs2.patch
>     fs-affs-return-f_fsid-for-statfs2.patch
>     fs-befs-return-f_fsid-for-statfs2.patch
>     fs-cramfs-return-f_fsid-for-statfs2.patch
>     fs-efs-return-f_fsid-for-statfs2.patch
>     fs-fat-return-f_fsid-for-statfs2.patch
>     fs-hfs-return-f_fsid-for-statfs2.patch
>     fs-hfsplus-return-f_fsid-for-statfs2.patch
>     fs-hpfs-return-f_fsid-for-statfs2.patch
>     fs-isofs-return-f_fsid-for-statfs2.patch
>     fs-minix-return-f_fsid-for-statfs2.patch
>     fs-omfs-return-f_fsid-for-statfs2.patch
Acked-by: Bob Copeland <me@bobcopeland.com>	
>     fs-qnx4-return-f_fsid-for-statfs2.patch
Acked-by: Anders Larsen <al@alarsen.net>
>     fs-reiserfs-return-f_fsid-for-statfs2.patch
This patch should not be included, since the bellowed v2 patch is here too.
>     fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
>     fs-romfs-return-f_fsid-for-statfs2.patch
>     fs-squashfs-return-f_fsid-for-statfs2.patch
>     fs-sysv-return-f_fsid-for-statfs2.patch
>     fs-ufs-return-f_fsid-for-statfs2.patch
Except jfs and udf, no feedback from other maintainers so far.

Thanks.
-- 
Coly Li
SuSE Labs
