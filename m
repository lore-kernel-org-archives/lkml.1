Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYHWJ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYHWJ3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 05:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYHWJ3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 05:29:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47420
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYHWJ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 05:29:36 -0400
Date: Sat, 23 Aug 2008 02:29:34 -0700 (PDT)
Message-Id: <20080823.022934.127206564.davem@davemloft.net>
To: Shyam_Iyer@Dell.com
Cc: akpm@linux-foundation.org, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, michaelc@cs.wisc.edu,
       swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com,
       leedom@chelsio.com
Subject: Re: [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA018D73BC@blrx3m10.blr.amer.dell.com>
References: <46A00B48CC54E4468EF6911F877AC4CA018D73BB@blrx3m10.blr.amer.dell.com>
	<20080823.012830.262443664.davem@davemloft.net>
	<46A00B48CC54E4468EF6911F877AC4CA018D73BC@blrx3m10.blr.amer.dell.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <Shyam_Iyer@Dell.com>
Date: Sat, 23 Aug 2008 14:37:53 +0530

> Exactly. And I am also suggesting that the driver version is not
> standard among different vendors.

It should not be standardized because every driver maintainer works
differently, and every driver is developed differently, and therefore
has different needs and desires for the version number.

All that matters is that the driver version makes sense to the
person maintaining the driver, and works for them when reviewing
bug reports.

Look, what you're suggesting is to change existing practice and that
doesn't belong in the discussion of the review of a specific driver.
If you want to bring that up as a topic and change globally how that
is handled, bring that up as a seperate topic on linux-kernel.

Don't bug the poor driver submitter who is just following existing
and accepted practice.
