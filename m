Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYCCUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYCCUTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759615AbYCCUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:19:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33215
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754947AbYCCUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:19:32 -0500
Date: Mon, 03 Mar 2008 12:19:16 -0800 (PST)
Message-Id: <20080303.121916.179359042.davem@davemloft.net>
To: marcel@holtmann.org
Cc: hidave.darkstar@gmail.com, tglx@linutronix.de,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] l2cap info_timer delete fix in hci_conn_del
From: David Miller <davem@davemloft.net>
In-Reply-To: <B208AF85-1FAD-4913-ADD6-4A1FD2D33F3C@holtmann.org>
References: <20080303024845.GA3197@darkstar.te-china.tietoenator.com>
	<B208AF85-1FAD-4913-ADD6-4A1FD2D33F3C@holtmann.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 3 Mar 2008 11:59:04 +0100

> the comment should say l2cap_conn_del, but besides that, the patch is  
> good.

I've fixed up the changelog message.

> Acked-by: Marcel Holtmann <marcel@holtmann.org>

And applied the patch, thanks everyone.
