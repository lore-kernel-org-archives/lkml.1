Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbXHWKCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbXHWKCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbXHWKCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:02:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:48880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbXHWKCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:02:42 -0400
Date: Thu, 23 Aug 2007 12:56:28 +0200
From: Andi Kleen <ak@suse.de>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [discuss] [PATCH] Implement missing x86_64 function smp_call_function_mask()
Message-ID: <20070823105628.GM8058@bingen.suse.de>
References: <46CD38E5.4000704@bull.net> <200708231125.38816.ak@suse.de> <46CD54B5.6050200@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CD54B5.6050200@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 11:34:45AM +0200, Laurent Vivier wrote:
> Andi Kleen wrote:
> > On Thursday 23 August 2007 09:36:05 Laurent Vivier wrote:
> >> This patch defines the missing function smp_call_function_mask() for x86_64,
> >> this is more or less a cut&paste of i386 function.
> > 
> > What do you need it for?
> 
> Hi Andi,
> 
> it is for KVM:

So put that into the description please.

-Andi
