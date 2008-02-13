Return-Path: <linux-kernel-owner+w=401wt.eu-S1764861AbYBMGCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764861AbYBMGCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYBMGB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:01:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56760
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbYBMGB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:01:57 -0500
Date: Tue, 12 Feb 2008 22:02:28 -0800 (PST)
Message-Id: <20080212.220228.254328299.davem@davemloft.net>
To: sdiz@sdiz.net
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla
 #9027)
From: David Miller <davem@davemloft.net>
In-Reply-To: <47B266AE.3040908@sdiz.net>
References: <47B266AE.3040908@sdiz.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SDiZ <sdiz@sdiz.net>
Date: Wed, 13 Feb 2008 11:40:30 +0800

> This patch fix bugzilla #9027.
> ``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
> connection handle 92" message"
> 
> see http://bugzilla.kernel.org/show_bug.cgi?id=9027

Marcel, please ACK and I'll push this along for you.

Thanks.
