Return-Path: <linux-kernel-owner+w=401wt.eu-S1764084AbZEAWWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764084AbZEAWWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbZEAWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:22:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55043
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbZEAWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:22:39 -0400
Date: Fri, 01 May 2009 15:22:33 -0700 (PDT)
Message-Id: <20090501.152233.267014258.davem@davemloft.net>
To: panther@balabit.hu
Cc: kaber@trash.net, mingo@elte.hu, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, hidden@sch.bme.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xt_socket: checks for the state of nf_conntrack
From: David Miller <davem@davemloft.net>
In-Reply-To: <1241105755-10017-1-git-send-email-panther@balabit.hu>
References: <1241105755-10017-1-git-send-email-panther@balabit.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laszlo Attila Toth <panther@balabit.hu>
Date: Thu, 30 Apr 2009 17:35:55 +0200

> xt_socket can use connection tracking, and checks whether it is a module.
> 
> Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

Applied, thanks.
