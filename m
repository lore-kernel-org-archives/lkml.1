Return-Path: <linux-kernel-owner+w=401wt.eu-S1751172AbZKYFxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbZKYFxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 00:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZKYFxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 00:53:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52810 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZKYFxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 00:53:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Nov 2009 14:50:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: stable <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH v2 -stable] memcg: avoid oom-killing innocent
 task in case of use_hierarchy
Message-Id: <20091125145026.9442135c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091125143218.96156a5f.nishimura@mxp.nes.nec.co.jp>
References: <20091124145759.194cfc9f.nishimura@mxp.nes.nec.co.jp>
	<20091124162854.fb31e81e.nishimura@mxp.nes.nec.co.jp>
	<20091125090050.e366dca5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091125143218.96156a5f.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 14:32:18 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > Hmm. Maybe not-expected behavior...could you add comment ?
> > 
> How about this ?
> 
seems nice. Thank you very much.

Regards,
-Kame

