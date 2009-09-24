Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZIXAFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZIXAFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZIXAFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:05:18 -0400
Received: from ozlabs.org ([203.10.76.45]:58386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZIXAFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:05:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH 8/13] cpumask: use mm_cpumask() wrapper: m32r
Date: Thu, 24 Sep 2009 09:35:13 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090612133101.0FF8BDDD0C@ozlabs.org> <swfiqf9okma.wl%takata@linux-m32r.org>
In-Reply-To: <swfiqf9okma.wl%takata@linux-m32r.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909240935.14607.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 10:59:01 pm Hirokazu Takata wrote:
> Hello,
> 
> I apologize for my too late reply.
> 
> I've checked the patch and fixed two typos.

Thanks!  This has been in linux-next for about two cycles, and I am
about to finally push to Linus.

Cheers,
Rusty.
