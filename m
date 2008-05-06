Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYEFFVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYEFFVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYEFFVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:21:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59396 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYEFFVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:21:33 -0400
Message-ID: <481FEA63.5060805@cn.fujitsu.com>
Date: Tue, 06 May 2008 13:19:31 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, FNST-Li Zefan <lizf@cn.fujitsu.com>,
       FNST-Wei Yongjun <yjwei@cn.fujitsu.com>,
       FNST-Shi Weihua <shiwh@cn.fujitsu.com>,
       FNST-Miao Xie <miaox@cn.fujitsu.com>,
       FNST-Li Yewang <lyw@cn.fujitsu.com>,
       FNST-Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com,
       FJ-Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: china email failures...
References: <20080505.130755.216189613.davem@davemloft.net>
In-Reply-To: <20080505.130755.216189613.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller said the following on 2008-5-6 4:07:
> Folks, if you have friends in China, you may let them know
> that we've been increasing seeing site-wide bounce problems
> lasting days here at vger that require us to remove lots of
> people from the lists.
> 
> This isn't isolated to one or two sites, it's been seen for
> anything from yahoo.com.cn to fujitsu.com.cn
> 
> The error is always the same:
> 
> 	User not local; please try <forward-path>
> 
> and every recipient at the site fails this way.
> 
> I don't know what causes this, or why it's seemingly only
> hitting sites in China.  But when it happens I have absolutely
> no way to contact the people who I have to unsubscribe because
> my emails to them fail in a similar way.
> 

I am truly sorry for that.

Seems that during China's golden week(4.30~5.4), my colleagues'
machines all be shutdowned, then fujitsu.com.cn's mail server
bounced flood mails which came from vger because no client fetches
mail from server.

I will contact with our Internet administrator to take care of this
thing.

Again apologize for that.

--WCN

