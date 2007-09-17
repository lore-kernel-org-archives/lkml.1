Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbXIQQ1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbXIQQ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXIQQ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:27:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40543
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbXIQQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:27:17 -0400
Date: Mon, 17 Sep 2007 09:27:08 -0700 (PDT)
Message-Id: <20070917.092708.112622378.davem@davemloft.net>
To: avi@qumranet.com
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       nix.or.die@googlemail.com
Subject: Re: [PATCH 045/104] KVM: Fix defined but not used warning in
 drivers/kvm/vmx.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <11900179473956-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
	<11900179473956-git-send-email-avi@qumranet.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


You've got to be kidding me.

104 patches is way over the top, post them in smaller chunks
please instead of killing vger.kernel.org as it has to crunch
out every single one of these 104 patches to several thousand
recipients.
