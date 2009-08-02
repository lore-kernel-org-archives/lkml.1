Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZHBTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZHBTz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZHBTz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:55:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59196
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbZHBTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:55:27 -0400
Date: Sun, 02 Aug 2009 12:55:35 -0700 (PDT)
Message-Id: <20090802.125535.13404927.davem@davemloft.net>
To: heder@google.com
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, joe@perches.com, jengelh@medozas.de,
       horms@verge.net.au
Subject: Re: [PATCH v3 2/2] IPVS: use pr_err and friends instead of
 IP_VS_ERR and friends
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090731113155.22420.59863.stgit@jazzy.zrh.corp.google.com>
References: <20090731113155.22420.59863.stgit@jazzy.zrh.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <heder@google.com>
Date: Fri, 31 Jul 2009 13:31:55 +0200

> Since pr_err and friends are used instead of printk there is not point
> in keeping IP_VS_ERR and friends.  Furthermore make use of '__func__'
> instead of hard coded function names.
> 
> Signed-off-by: Hannes Eder <heder@google.com>

This patch does not apply to net-next-2.6.
