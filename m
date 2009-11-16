Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZKPXer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZKPXer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZKPXeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:34:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38947 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZKPXep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:34:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911152209350.29917@sister.anvils>
References: <20091113151554.33C2.A69D9226@jp.fujitsu.com> <Pine.LNX.4.64.0911152209350.29917@sister.anvils>
Message-Id: <20091117083403.3DAE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 08:34:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 13 Nov 2009, KOSAKI Motohiro wrote:
> > 
> > Very small nit. How about this?
> 
> Yes, that takes it a stage further, I prefer that, thanks: but better
> redo against mmotm, I removed the "MLOCK_PAGES && " in a later patch.

Ah, yes.
thanks.

I'll redo.



