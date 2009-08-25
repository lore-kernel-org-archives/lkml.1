Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZHYKEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZHYKEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZHYKEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:04:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35059 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbZHYKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:04:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 25 Aug 2009 19:02:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: xiyou.wangcong@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090825190247.f7353bc8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009 16:28:30 -0700
akpm@linux-foundation.org wrote:

> kcore-use-usual-list-for-kclist.patch
> kcore-add-kclist-type.patch
> kcore-register-vmalloc-area-in-generic-way.patch
> kcore-register-text-area-in-generic-way.patch
> walk-system-ram-range.patch
> kcore-use-registerd-physmem-information.patch
> kcore-use-registerd-physmem-information-fix.patch
> kcore-use-registerd-physmem-information-checkpatch-fixes.patch
> kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
> kcore-use-registerd-physmem-information-fix2.patch

These patches are reported to break bisection.
If dropped, I'll remake.

Sorry for my lack of skill.
-Kame

