Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYFIQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYFIQ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYFIQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:26:54 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13055 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYFIQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:26:53 -0400
Date: Mon, 9 Jun 2008 09:27:05 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, nagar@watson.ibm.com,
       balbir@in.ibm.com, sekharan@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3 v2] per-task-delay-accounting: update taskstats for
 memory reclaim delay
Message-Id: <20080609092705.acf31b91.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080607134129.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <4848B983.4030502@linux.vnet.ibm.com>
	<20080606172437.bcd7d98a.kobayashi.kk@ncos.nec.co.jp>
	<20080607134129.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jun 2008 13:44:07 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> The code of this patch looks good to me.
> but this change log isn't so good.
> 
> Do you want remain email bare discssion on git log?
> 

Thanks for your comment.

But I confirmed this patch did not remain
"email bare discssion" on git log.
