Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZGJAIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZGJAIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbZGJAH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:07:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38858
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZGJAH6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:07:58 -0400
Date: Thu, 09 Jul 2009 17:08:01 -0700 (PDT)
Message-Id: <20090709.170801.136290456.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jolsa@redhat.com, netdev@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       fbl@redhat.com, nhorman@redhat.com, htejun@gmail.com, jarkao2@gmail.com,
       oleg@redhat.com, davidel@xmailserver.org
Subject: Re: [PATCHv7 1/2] net: adding memory barrier to the poll and
 receive callbacks
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A5570E7.4010901@gmail.com>
References: <20090708220717.GB2945@jolsa.redhat.com>
	<20090708220913.GC2945@jolsa.redhat.com>
	<4A5570E7.4010901@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 09 Jul 2009 06:24:07 +0200

> Jiri Olsa a écrit :
>> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
