Return-Path: <linux-kernel-owner+w=401wt.eu-S967909AbXFHDvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967909AbXFHDvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967412AbXFHDvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:51:05 -0400
Received: from holomorphy.com ([66.93.40.71]:39406 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967372AbXFHDvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:51:02 -0400
Date: Thu, 7 Jun 2007 20:51:18 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Lord <lkml@rtr.ca>, Andi Kleen <ak@suse.de>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070608035118.GY6909@holomorphy.com>
References: <20070608023551.GJ15426@holomorphy.com> <20070607194156.d4aacf4c.akpm@linux-foundation.org> <20070608030629.GW6909@holomorphy.com> <4668CF2E.8000707@zytor.com> <20070608034121.GX6909@holomorphy.com> <4668D089.5090209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4668D089.5090209@zytor.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> Beg your pardon? Are you reading the patch description correctly?

On Thu, Jun 07, 2007 at 08:44:09PM -0700, H. Peter Anvin wrote:
> I mean, with your patch CONFIG_HIGHMEM4G versus CONFIG_HIGHMEM64G really
> don't make sense as separate selections anymore.

I thought about sweeping those up, but defaulted to minimal diffsize.
I can sweep them up given more votes in favor of doing so.


-- wli
