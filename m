Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbZEML1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbZEML1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZEML1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:27:10 -0400
Received: from cmpxchg.org ([85.214.51.133]:41706 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZEML1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:27:09 -0400
Date: Wed, 13 May 2009 13:24:48 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Message-ID: <20090513112448.GB2254@cmpxchg.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513172904.7234.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 05:30:45PM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
> 
> Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
> used only embedded people.
> Thus, moving it into embedded submenu is better.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
