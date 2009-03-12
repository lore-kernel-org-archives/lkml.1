Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZCLFdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZCLFdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZCLFdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:33:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53571 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZCLFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:33:40 -0400
Date: Thu, 12 Mar 2009 14:32:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-Id: <20090312143212.50818cd5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312050423.GI23583@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312034647.GA23583@balbir.in.ibm.com>
	<20090312133949.130b20ed.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312050423.GI23583@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 10:34:23 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Not yet.. you just posted it. I am testing my v5, which I'll post
> soon. I am seeing very good results with v5. I'll test yours later
> today.
> 

If "hooks" to usual path doesn't exist and there are no global locks,
I don't have much concern with your version.
But 'sorting' seems to be overkill to me.

I'm sorry if my responce to your patch is delayed. I may not be in office.

Thanks,
-Kame



