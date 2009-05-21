Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZEUDkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZEUDkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZEUDkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:40:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55878
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbZEUDkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:40:08 -0400
Date: Wed, 20 May 2009 20:40:06 -0700 (PDT)
Message-Id: <20090520.204006.199124752.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: menage@google.com, akpm@linux-foundation.org, tgraf@suug.ch,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [PATCH] cls_cgroup: read classid atomically in classifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A14A506.2000601@cn.fujitsu.com>
References: <20090520173426.15291.93021.stgit@menage.mtv.corp.google.com>
	<4A14A506.2000601@cn.fujitsu.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 21 May 2009 08:49:10 +0800

> (better CC netdev)

linux-net != netdev :-)

Also the original should be sent there so that the patch is
properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/
