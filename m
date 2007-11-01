Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXKAWAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXKAWAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXKAV76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:59:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45573
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbXKAV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:59:57 -0400
Date: Thu, 01 Nov 2007 14:59:56 -0700 (PDT)
Message-Id: <20071101.145956.63020380.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: djohnson+linux-kernel@sw.starentnetworks.com, greearb@candelatech.com,
       shemminger@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bguo@sw.starentnetworks.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <472A49BD.6000802@hp.com>
References: <4729EAFF.9050606@candelatech.com>
	<18218.18134.353553.189622@zeus.sw.starentnetworks.com>
	<472A49BD.6000802@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Thu, 01 Nov 2007 14:48:45 -0700

> One could I suppose try to ammend the information passed to allow
> tcpdump to say "oh, this was a tx packet on the same machine on
> which I am tracing so don't worry about checksum mismatch"

We do this already!

