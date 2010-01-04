Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293Ab0ADFoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0ADFoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275Ab0ADFoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:44:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51850
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab0ADFoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:44:32 -0500
Date: Sun, 03 Jan 2010 21:44:35 -0800 (PST)
Message-Id: <20100103.214435.119221597.davem@davemloft.net>
To: rakesh@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
       michaelc@cs.wisc.edu, james.bottomley@hansenpartnership.com,
       kxie@chelsio.com
Subject: Re: [RESEND PATCH 1/1]cxgb3i: Fix a login over vlan issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0912271235370.12420@rakeshpc.asicdesigner.com>
References: <alpine.LFD.2.00.0912271235370.12420@rakeshpc.asicdesigner.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Ranjan <rakesh@chelsio.com>
Date: Sun, 27 Dec 2009 12:41:58 +0530 (IST)

> From: Rakesh Ranjan <rakesh@chelsio.com>
> Date: Sun, 27 Dec 2009 12:33:08 +0530
> Fix a target login issue, when parent interface is vlan and we are using cxgb3i sepecific
> private ip address in '/etc/iscsi/ifaces/' iface file.
> 
> Acked-by: Karen Xie <kxie@chelsio.com>
> Signed-off-by: Rakesh Ranjan <rakesh@chelsio.com>

Applied.
