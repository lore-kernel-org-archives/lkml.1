Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYAULOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYAULOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 06:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYAULON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 06:14:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38953
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756464AbYAULOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 06:14:12 -0500
Date: Mon, 21 Jan 2008 03:14:17 -0800 (PST)
Message-Id: <20080121.031417.171098597.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, cornelia.huck@de.ibm.com,
       gombasg@sztaki.hu, htejun@gmail.com, viro@zeniv.linux.org.uk,
       kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] bluetooth : move children of connection device to NULL
 before connection down
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080121045401.GB4162@darkstar.te-china.tietoenator.com>
References: <20080121044913.GA4162@darkstar.te-china.tietoenator.com>
	<20080121045401.GB4162@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 21 Jan 2008 12:54:01 +0800

> Add people missed in cc-list.

Thanks Dave for your continued efforts on Bluetooth bugs like this.

Marcel, are you going to review/ACK/integrate/push-upstream/whatever
any of these Bluetooth patches?

It hasn't been getting much love from you as of late, you are one of
the listed maintainers, and I don't want to lose any of Dave's
valuable bug fixing work.

Or should I just handle it all directly?

Thanks.
