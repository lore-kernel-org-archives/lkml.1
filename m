Return-Path: <linux-kernel-owner+w=401wt.eu-S1764660AbXGSW3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764660AbXGSW3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbXGSW31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:29:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830AbXGSW31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:29:27 -0400
Date: Thu, 19 Jul 2007 15:29:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Shimmin <tes@sgi.com>
cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] XFS update
In-Reply-To: <469F7329.9080603@sgi.com>
Message-ID: <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
References: <469F7329.9080603@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Tim Shimmin wrote:
> 
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

Ok, this got some conflicts with Nick's VM fault patches, but I fixed them 
up since they looked trivial, and pushed out the result. Please do verify 
that it all works and makes sense, though...

		Linus
