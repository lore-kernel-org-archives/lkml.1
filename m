Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506Ab0ACXss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0ACXss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837Ab0ACXss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:48:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41131 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0ACXsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:48:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 4 Jan 2010 08:45:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/4] vmscan: get_scan_ratio cleanup
Message-Id: <20100104084534.dbf06a21.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228164733.A68A.A69D9226@jp.fujitsu.com>
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
	<20091228164733.A68A.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 16:48:06 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> The get_scan_ratio() should have all scan-ratio related calculations.
> Thus, this patch move some calculation into get_scan_ratio.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

