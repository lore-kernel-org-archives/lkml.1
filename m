Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0CKEpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:45:36 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:45953 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0CKEpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:45:34 -0500
Date: Thu, 11 Mar 2010 10:15:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Greg Thelen <gthelen@google.com>, Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] mm: fix typo in refill_stock() comment
Message-ID: <20100311044526.GB17643@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1268255117-3280-1-git-send-email-gthelen@google.com>
 <20100311093226.8f361e38.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100311093226.8f361e38.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-03-11 09:32:26]:

> On Wed, 10 Mar 2010 13:05:17 -0800, Greg Thelen <gthelen@google.com> wrote:
> > Change refill_stock() comment: s/consumt_stock()/consume_stock()/
> > 
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>

Thanks for catching and fixing this.
 
-- 
	Three Cheers,
	Balbir
