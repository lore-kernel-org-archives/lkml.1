Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZHTFaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZHTFaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZHTFaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:30:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37614 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZHTFaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:30:12 -0400
Date: Thu, 20 Aug 2009 06:30:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
In-Reply-To: <20090820152743.a5f1088b.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.0908200629470.16909@skynet.skynet.ie>
References: <20090820152743.a5f1088b.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Dave,
> 
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/radeon/radeon_ttm.c between commit
> ad49f501867cba87e1e45e5ebae0b12435d68bf1 ("drm/ttm/radeon: add dma32
> support") from Linus' tree and commit
> a987fcaa805fcb24ba885c2e29fd4fdb6816f08f ("ttm: Make parts of a struct
> ttm_bo_device global") from the drm tree.

I merged Linus tree soon after and pushed it out so it should be okay now.

Dave.
