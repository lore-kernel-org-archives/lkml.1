Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZHCB3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZHCB3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZHCB3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:29:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33396
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbZHCB3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:29:48 -0400
Date: Sun, 02 Aug 2009 18:29:56 -0700 (PDT)
Message-Id: <20090802.182956.263159793.davem@davemloft.net>
To: horms@verge.net.au
Cc: heder@google.com, lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, joe@perches.com, jengelh@medozas.de
Subject: Re: [PATCH v4 2/2] IPVS: use pr_err and friends instead of
 IP_VS_ERR and friends
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090803003658.GQ6177@verge.net.au>
References: <20090802210530.14843.62378.stgit@jazzy.zrh.corp.google.com>
	<20090803003658.GQ6177@verge.net.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Mon, 3 Aug 2009 10:36:59 +1000

> On Sun, Aug 02, 2009 at 11:05:41PM +0200, Hannes Eder wrote:
>> Since pr_err and friends are used instead of printk there is no point
>> in keeping IP_VS_ERR and friends.  Furthermore make use of '__func__'
>> instead of hard coded function names.
>> 
>> Signed-off-by: Hannes Eder <heder@google.com>
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks.

