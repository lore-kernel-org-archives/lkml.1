Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZGCD2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZGCD2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 23:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZGCD2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 23:28:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48618 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZGCD2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 23:28:34 -0400
Date: Fri, 3 Jul 2009 08:58:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] cgroup avoid permanent sleep at rmdir v6
Message-ID: <20090703032834.GT11273@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090703093154.5f6e910a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090703093154.5f6e910a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-07-03 09:31:54]:

> Applied all comments.
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>

Looks good to me, there are sufficient reviewed-by and other acks, but
here goes anyway

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
