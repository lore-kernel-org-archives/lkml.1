Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZAODVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZAODVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZAODVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:21:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42816 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZAODVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:21:39 -0500
Date: Thu, 15 Jan 2009 04:36:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: Mainline kernel OLTP performance update
Message-ID: <20090115033620.GT23848@one.firstfloor.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <874p01fg3a.fsf@basil.nowhere.org> <20090115024740.GX29283@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115024740.GX29283@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This particular system has 450 spindles, but they're amalgamated into
> 30 logical volumes by the hardware or firmware.  Linux sees 30 LUNs.
> Each one, though, has fifteen partitions on it, so that brings us back
> up to 450 partitions.

Thanks for the correction.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
