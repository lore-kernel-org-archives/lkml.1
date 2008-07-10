Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYGJJPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYGJJPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYGJJOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:14:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYGJJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:14:52 -0400
Date: Thu, 10 Jul 2008 02:08:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
Message-Id: <20080710020848.066cfc8c.akpm@linux-foundation.org>
In-Reply-To: <1209742841.12502.40.camel@odin>
References: <1209742841.12502.40.camel@odin>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 16:40:41 +0100 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This is an updated version of the kernel voltage & current regulator
> framework based on comments received from version 3 of the patch series.

git-regulator.patch has been in -mm for two months without incident.  I'd
forgotten about it.   This is bad - we should have put it into linux-next.

If you hope to get this into 2.6.27 then please send the git URL to Stephen
and the linux-next list asap.  Please also resend the patches to this list
for re-review.  Then, if it doesn't get shot down, send Linux a pull
request during the 2.6.27 merge window.  ie: about one week from today.

Thanks.
