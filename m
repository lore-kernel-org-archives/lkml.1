Return-Path: <linux-kernel-owner+w=401wt.eu-S1764075AbXGQRhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764075AbXGQRhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXGQRhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:37:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbXGQRhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:37:40 -0400
Date: Tue, 17 Jul 2007 10:37:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] more drm patches for 2.6.23-rc1
In-Reply-To: <Pine.LNX.4.64.0707170530480.23577@skynet.skynet.ie>
Message-ID: <alpine.LFD.0.999.0707171037070.19166@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707170212310.2500@skynet.skynet.ie>
 <alpine.LFD.0.999.0707162055380.19166@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707170530480.23577@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Dave Airlie wrote:
> 
> Could you re-pull?
> 
> There are two patches, one fixes a missed typedef for Sis and one adds the
> idr_init that fell out of the drawable changeset.. which should fix any
> hangs..

Yup, hang fixed. Thanks,

		Linus
