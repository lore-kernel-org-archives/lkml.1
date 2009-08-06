Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZHFMIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZHFMIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZHFMIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:08:31 -0400
Received: from ozlabs.org ([203.10.76.45]:57740 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbZHFMIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:08:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] lguest: cleanup for map_switcher()
Date: Thu, 6 Aug 2009 21:38:24 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Atsushi SAKAI <sakaia@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org
References: <4A79540D.6060207@cn.fujitsu.com>
In-Reply-To: <4A79540D.6060207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908062138.24950.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 07:12:37 pm Xiao Guangrong wrote:
> We can use alloc_page() instead of get_zeroed_page() and virt_to_page()

Applied, thanks!
Rusty.
