Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXDLVUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXDLVUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXDLVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:19:59 -0400
Received: from are.twiddle.net ([64.81.246.98]:52286 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbXDLVT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:19:59 -0400
Date: Thu, 12 Apr 2007 14:16:39 -0700
From: Richard Henderson <rth@twiddle.net>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: build fixes - force architecture (take 2)
Message-ID: <20070412211639.GA23340@twiddle.net>
Mail-Followup-To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
References: <20070412120110.A25812@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412120110.A25812@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 12:01:10PM +0400, Ivan Kokshaysky wrote:
> [CIX stuff reworked, .got change dropped as Richard suggested]
> 
> Override compiler .arch directive for generic kernel build.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Signed-off-by: Richard Henderson  <rth@twiddle.net>



r~
