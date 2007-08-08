Return-Path: <linux-kernel-owner+w=401wt.eu-S937886AbXHHUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937886AbXHHUX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934989AbXHHUXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:23:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbXHHUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:23:19 -0400
Date: Wed, 8 Aug 2007 13:18:12 -0700
From: Richard Henderson <rth@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: arch maintainers: define O_CLOEXEC correctly!
Message-ID: <20070808201812.GA9360@redhat.com>
References: <46B3613C.60007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B3613C.60007@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:09:16AM -0700, Ulrich Drepper wrote:
> Alpha:   probably needs value 010000000

Thanks.  Patch sent.


r~
