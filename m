Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbXEQGvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbXEQGvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbXEQGvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:51:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbXEQGvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:51:11 -0400
Date: Wed, 16 May 2007 23:51:11 -0700 (PDT)
Message-Id: <20070516.235111.07638844.davem@davemloft.net>
To: ssatyam@cse.iitk.ac.in
Cc: akpm@linux-foundation.org, marcel@holtmann.org, jikos@jikos.cz,
       gregkh@suse.de, jeremy@goop.org, maxk@qualcomm.com, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: fix locking in hci_sock_dev_event()
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705171106550.9262@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0705171106550.9262@cselinux1.cse.iitk.ac.in>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Date: Thu, 17 May 2007 11:13:36 +0530 (IST)

> [PATCH] bluetooth: fix locking in hci_sock_dev_event()

BTW, your email client corrupted the patch spaces and tabs
a lot, I applied your patch by hand but I will not do that
next time.  Please look into getting your email client to
not corrupt the patches you send out, thank you.
