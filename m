Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZBSGel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZBSGel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZBSGea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:34:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZBSGe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:34:29 -0500
Message-ID: <499CFDC8.1070600@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 14:35:52 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH 00/12]Next:Get rid of all the old micro DMA_XXBIT_MASK and
 use DMA_BIT_MASK(n) instead
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all DMA_XXBIT_MASK micro with new DMA_BIT_MASK(n) micro

01:Replace all DMA_64BIT_MASK micro with DMA_BIT_MASK(64)
02:Replace all DMA_48BIT_MASK micro with DMA_BIT_MASK(48)
03:Replace all DMA_40BIT_MASK micro with DMA_BIT_MASK(40)
04:Replace all DMA_39BIT_MASK micro with DMA_BIT_MASK(39)
05:Replace all DMA_35BIT_MASK micro with DMA_BIT_MASK(35)
06:Replace all DMA_32BIT_MASK micro with DMA_BIT_MASK(32)
07:Replace all DMA_31BIT_MASK micro with DMA_BIT_MASK(31)
08:Replace all DMA_30BIT_MASK micro with DMA_BIT_MASK(30)
09:Replace all DMA_28BIT_MASK micro with DMA_BIT_MASK(28)
10:Replace all DMA_24BIT_MASK micro with DMA_BIT_MASK(24)
11:Remove defines of DMA_XXBIT_MASK micro
12:Update related documentations


-- 
Regards
Yang Hongyang



