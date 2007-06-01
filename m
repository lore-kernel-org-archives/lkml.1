Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXFAF5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXFAF5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXFAF5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:57:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41576 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbXFAF5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:57:31 -0400
Date: Fri, 01 Jun 2007 14:56:43 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparsemem: Shut up unused symbol compiler warnings.
In-Reply-To: <20070601053404.GA8841@linux-sh.org>
References: <20070601142124.91F8.Y-GOTO@jp.fujitsu.com> <20070601053404.GA8841@linux-sh.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070601145517.9204.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jun 01, 2007 at 02:26:17PM +0900, Yasunori Goto wrote:
> > I think this issue is fixed by
> > move-three-functions-that-are-only-needed-for.patch in current -mm tree.
> > Is it not enough?
> > 
> That's possible, I hadn't checked -mm. This was simply against current
> git. If there's already a fix in -mm, then this can simply be ignored.

Okay. Thanks for your report.

-- 
Yasunori Goto 


