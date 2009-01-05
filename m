Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZAEJId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZAEJId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZAEJIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:08:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbZAEJIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:08:12 -0500
Date: Mon, 5 Jan 2009 01:07:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>,
       Mike Waychison <mikew@google.com>, Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090105010726.c0433fea.akpm@linux-foundation.org>
In-Reply-To: <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Mon,  5 Jan 2009 18:00:33 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > #
> > page_fault-retry-with-nopage_retry.patch
> > page_fault-retry-with-nopage_retry-fix.patch
> > page_fault-retry-with-nopage_retry-fix-fix.patch
> 
> I oppose this.
> 
> Valdis.Kletnieks@vt.edu reported this patch has bug in
> "28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
> thread.
> 
> Nobody answer his question yet.

OK, thanks.  I actually thought we'd fixed that?
