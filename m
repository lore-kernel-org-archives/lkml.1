Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbXIKIWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbXIKIWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762000AbXIKIVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:21:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761809AbXIKIVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:21:41 -0400
Date: Tue, 11 Sep 2007 01:21:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
Message-Id: <20070911012124.8bf52eb4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709110907240.11816@skynet.skynet.ie>
References: <20070905071152.GA5817@zhen-devel.sh.intel.com>
	<20070905081937.35965e97.randy.dunlap@oracle.com>
	<20070906012852.GA8058@zhen-devel.sh.intel.com>
	<20070910221316.d31af0dd.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0709110907240.11816@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 09:08:08 +0100 (IST) Dave Airlie <airlied@linux.ie> wrote:

> Andrew I meant to upstream these for 2.6.23 but travelling is still in 
> progress, so if you could send them to Linus...
> 
> Acked-by: Dave Airlie <airlied@linux.ie>

No probs, thanks.
