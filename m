Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYHMUNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYHMUNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYHMUNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:13:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41262
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYHMUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:13:23 -0400
Date: Wed, 13 Aug 2008 13:13:24 -0700 (PDT)
Message-Id: <20080813.131324.32902022.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: vst@vlnb.net, open-iscsi@googlegroups.com, rdreier@cisco.com,
       rick.jones2@hp.com, swise@opengridcomputing.com, kxie@chelsio.com,
       netdev@vger.kernel.org, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A33633.20800@pobox.com>
References: <200808121521.10101.divy@chelsio.com>
	<48A32976.7060504@vlnb.net>
	<48A33633.20800@pobox.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Wed, 13 Aug 2008 15:29:55 -0400

> * direct data placement is possible without offloading the entire TCP 
> stack onto a firmware/chip.

I've even described in this thread how that's possible.
