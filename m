Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZFIA5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZFIA5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZFIA44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:56:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZFIA4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:56:55 -0400
Message-ID: <4A2DB36F.1040406@cn.fujitsu.com>
Date: Tue, 09 Jun 2009 08:57:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace: change the export format of trace_kfree_skb()
References: <4A2CD77F.7080609@cn.fujitsu.com> <20090608102508.GA4304@hmsreliant.think-freely.org>
In-Reply-To: <20090608102508.GA4304@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Neil Horman wrote:
> 
> No objection to the code change, but whats with the new mode?  Why are you
> making the file executable?
> 

Hi Neil:

Thanks for your review, this is my mistake, I'll fix it in v2 patch.

Thanks,
Xiao Guangrong

> Neil
> 
> 
> 
