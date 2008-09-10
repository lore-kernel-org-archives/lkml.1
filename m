Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbYIJKjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbYIJKjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIJKjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:39:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:48128 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYIJKjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="334807418"
From: "Yang, Sheng" <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
Date: Wed, 10 Sep 2008 18:42:30 +0800
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <12209432941440-git-send-email-sheng.yang@intel.com> <86802c440809091045h2d4f1776g94355e1b1dd1b29e@mail.gmail.com> <20080910080421.GC15255@elte.hu>
In-Reply-To: <20080910080421.GC15255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101842.31355.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 16:04:21 Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Tue, Sep 9, 2008 at 1:05 AM, Yang, Sheng <sheng.yang@intel.com> wrote:
> > > Yeah, I've considered that, but seems duplicate for both files? The
> > > feature detection code is the same. Any way to merge them?
> >
> > just merged intel_64.c into intel.c...
>
> it's all in tip/master:
>
>   http://people.redhat.com/mingo/tip.git/README
>
> would it be possible to get a patchset ontop of that?
>
> 	Ingo

So quick.... 
Thanks Yinghai!

Would send the updated patch soon.
-- 
regards
Yang, Sheng
