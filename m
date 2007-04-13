Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXDMULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXDMULU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXDMULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:11:20 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:4996 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXDMULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:11:19 -0400
Date: Sat, 14 Apr 2007 00:11:24 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: build fixes - force architecture (take 2)
Message-ID: <20070414001124.A2004@jurassic.park.msu.ru>
References: <20070412120110.A25812@jurassic.park.msu.ru> <20070412211639.GA23340@twiddle.net> <20070413120503.28466a25.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070413120503.28466a25.akpm@linux-foundation.org>; from akpm@linux-foundation.org on Fri, Apr 13, 2007 at 12:05:03PM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:05:03PM -0700, Andrew Morton wrote:
> alpha-fix-bootp-image-creation.patch
> alpha-prctl-macros.patch
> alpha-fixes-for-specific-machine-types.patch
> alpha-more-fixes-for-specific-machine-types.patch
> alpha-build-fixes-force-architecture.patch
> 
> Which of these do you think should be in 2.6.21?

The last one, definitely. Of course, it would be nice to get the
"specific machine" stuff there too, but it's not so critical.

Ivan.
