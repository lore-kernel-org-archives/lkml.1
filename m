Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbXDMHIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbXDMHIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXDMHIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:08:31 -0400
Received: from holomorphy.com ([66.93.40.71]:37721 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXDMHIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:08:31 -0400
Date: Fri, 13 Apr 2007 00:08:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413070845.GR2986@holomorphy.com>
References: <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EFB98.8050408@yahoo.com.au> <20070413065545.GQ2986@holomorphy.com> <461F2B4F.90506@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461F2B4F.90506@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> The EM guys are unwilling or unable for support-oriented reasons to
>> deal with anything but unmodified kernels as shipped by distros.

On Fri, Apr 13, 2007 at 05:03:43PM +1000, Nick Piggin wrote:
> And I think major distros ship with kprobes enabled, so that is yet
> another reason why systemtap should be considered before adding these
> proc interfaces.

I'll have to check in and see if that will work for them. A lot of this
is about customer/distro/support interaction constraints on how it works
as opposed to purely technical affairs.


-- wli
