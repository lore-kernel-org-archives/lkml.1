Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZA0Rvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZA0Rvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZA0Rvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:51:38 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:59557 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZA0Rvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:51:37 -0500
Date: Tue, 27 Jan 2009 23:21:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [mmotm] Backtrace __change_page_attr_set_clr
Message-ID: <20090127175131.GR504@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090127110823.GO504@balbir.in.ibm.com> <20090127083705.56e210e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090127083705.56e210e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-01-27 08:37:05]:

> On Tue, 27 Jan 2009 16:38:23 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> OK, thanks.  It looks like you cc'ed the right person ;)
> 
> The code in current linux-next has changed a bit since 16 Jan. 
> Hopefully this warning from dmidecode got fixed.
>

I'll test linux-next or -tip and see the status of the issue
 
> I'm still quite backlogged from the week overseas, and I've been
> reluctant to do another mmotm because it would probably be an
> uncompileable pile of junk.

That explains it all, with LCA it was expected :) I am still trying to
get used to 2009.

-- 
	Balbir
