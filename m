Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZJPNZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZJPNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbZJPNZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:25:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:37149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256AbZJPNY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:24:58 -0400
Date: Fri, 16 Oct 2009 15:24:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, users@host1.serialmonkey.com,
       linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org,
       linux-ext4@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-sctp@vger.kernel.org
Subject: Re: [PATCH 7/8] trivial: fix many typos s/untill/until/
In-Reply-To: <1255638072-6236-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0910161523400.8582@wotan.suse.de>
References: <1255638072-6236-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
>  drivers/net/bonding/bond_alb.c           |    2 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c  |    2 +-
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         |    2 +-
>  drivers/staging/rtl8187se/r8180.h        |    2 +-
>  fs/ext4/balloc.c                         |    2 +-
>  net/bluetooth/bnep/core.c                |    2 +-
>  net/sctp/sm_statefuns.c                  |    2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)

Merged together with patches 2-8 from your series and applied to trivial 
queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
