Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbXHXFOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbXHXFOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 01:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbXHXFOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 01:14:21 -0400
Received: from 1wt.eu ([62.212.114.60]:2289 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXHXFOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 01:14:21 -0400
Date: Fri, 24 Aug 2007 06:59:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v20, for v2.6.22.5, v2.6.21.7, v2.6.20.16
Message-ID: <20070824045912.GR6002@1wt.eu>
References: <20070823094346.GA26281@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823094346.GA26281@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Aug 23, 2007 at 11:43:46AM +0200, Ingo Molnar wrote:
> 
> By popular demand, here is release -v20 of the CFS scheduler. It is a 
> full backport of the latest & greatest v2.6.23-rc3 CFS code to 
> v2.6.22.5, v2.6.21.7 and v2.6.20.16.

Great, thanks a lot ! I had been grepping 2.6.23's shortlog to catch all
patches beginning with "sched:", hoping to miss none. I had caught up
with -rc2 with something that worked fairly well, but I never was 100%
sure it was OK.

So, once again, thanks ;-)
Willy

