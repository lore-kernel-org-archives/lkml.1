Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYDRGD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYDRGD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYDRGDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:03:21 -0400
Received: from cnc.isely.net ([64.81.146.143]:60449 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYDRGDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:03:20 -0400
Date: Fri, 18 Apr 2008 01:03:17 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Adrian Bunk <bunk@kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Video4Linux list <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: [2.6 patch] video/pvrusb2/pvrusb2-hdw.c cleanups
In-Reply-To: <20080414184153.GZ6695@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0804180100180.31065@cnc.isely.net>
References: <20080414184153.GZ6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Adrian Bunk wrote:

> This patch contains the following cleanups:
> - make the following needlessly global function static:
>   - pvr2_hdw_set_cur_freq()
> - #if 0 the following unused global functions:
>   - pvr2_hdw_get_state_name()
>   - pvr2_hdw_get_debug_info_unlocked()
>   - pvr2_hdw_get_debug_info_locked()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---

FYI, I've merged this change into my local repository, and expect to 
push it back up for 2.6.26 as part of a pent-up pile of pvrusb2 changes.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
