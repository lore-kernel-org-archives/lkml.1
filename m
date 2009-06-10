Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZFJIKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZFJIKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZFJIK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:10:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50039
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbZFJIKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:10:25 -0400
Date: Wed, 10 Jun 2009 01:10:27 -0700 (PDT)
Message-Id: <20090610.011027.43904351.davem@davemloft.net>
To: oliver@hartkopp.net
Cc: hawk@comx.dk, paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2D112A.4000308@hartkopp.net>
References: <20090608130959.10052.54590.stgit@localhost>
	<20090608131138.10052.5408.stgit@localhost>
	<4A2D112A.4000308@hartkopp.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <oliver@hartkopp.net>
Date: Mon, 08 Jun 2009 15:24:58 +0200

> Acked-By: Oliver Hartkopp <oliver@hartkopp.net>

Please don't capitalize the "By" in "Acked-By".  Otherwise
patchwork doesn't pick them up automatically.

It's just like "Signed-off-by", only the first word is capitalized.

Thank you.
