Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYFZBdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYFZBdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYFZBdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:33:02 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50613 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYFZBdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:33:01 -0400
Date: Thu, 26 Jun 2008 10:31:31 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 10/10] putback_lru_page()/unevictable page handling rework v4
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee.Schermerhorn@hp.com, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080625151316.58ed195e.akpm@linux-foundation.org>
References: <20080625191237.D86D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080625151316.58ed195e.akpm@linux-foundation.org>
Message-Id: <20080626103000.FCFC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And that's kind-of OK.  It's messy, but we could live with it.  However
> as I expect there will be more fixes to these patches before all this
> work goes into mainline, this particular patch will become more of a
> problem as it will make the whole body of work more messy and harder to
> review and understand.
> 
> So.  Can this patch be simplified in any way?  Or split up into
> finer-grained patches or something like that?

Yes, sir!
I'll do it.


