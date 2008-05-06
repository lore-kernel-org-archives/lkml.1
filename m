Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbYEFDau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbYEFDau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYEFDaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:30:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47031 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYEFDah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:30:37 -0400
Date: Tue, 06 May 2008 12:29:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 1/5] fix overflow problem of do_try_to_free_page()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Nishanth Aravamudan <nacc@us.ibm.com>
In-Reply-To: <20080505081239.GB22105@us.ibm.com>
References: <20080504215331.8F55.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080505081239.GB22105@us.ibm.com>
Message-Id: <20080506122626.AC58.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I'll repost patch 2-5 after refrect reviewer comment.
but I hope patch [1/5] merge into -mm soon.

Nishanth-san already acked me.
please.


> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> Eep, sorry -- my original version had used -EAGAIN to indicate a special
> condition, but this was removed before the final patch. Thanks for the
> catch.
> 
> Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> Should go upstream, as well.


