Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXKEGdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXKEGdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 01:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbXKEGdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 01:33:05 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48581 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXKEGdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 01:33:04 -0500
Date: Mon, 5 Nov 2007 06:33:03 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.sourceforge.net
Subject: Re: [PATCH series] DRM memory manager core
In-Reply-To: <Pine.LNX.4.64.0711050612110.8487@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0711050632030.8487@skynet.skynet.ie>
References: <Pine.LNX.4.64.0711050612110.8487@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I think its about time we merged this code, it is in an area of the 
> kernel wholly self-contained and mostly maintained by me, and adds a 
> feature that allows userspace graphics to leverage features of graphics 
> cards that only the binary vendors have done up until now.

And I mean to -mm now via my git tree,... and the kernel in the next 
revision..

Also we couldn't develop this stuff in-tree up until now as the API has 
undergone a major re-work and is only now what we consider stable..

Dave.
