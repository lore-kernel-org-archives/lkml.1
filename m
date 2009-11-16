Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZKPNSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZKPNSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZKPNST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:18:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36657
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbZKPNST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:18:19 -0500
Date: Mon, 16 Nov 2009 05:18:35 -0800 (PST)
Message-Id: <20091116.051835.125328285.davem@davemloft.net>
To: rakesh@chelsio.com
Cc: michaelc@cs.wisc.edu, open-iscsi@googlegroups.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de, kxie@chelsio.com
Subject: Re: [RFC-PATCH] libiscsi dhcp handler
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B014F95.8000906@chelsio.com>
References: <4B014F95.8000906@chelsio.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Ranjan <rakesh@chelsio.com>
Date: Mon, 16 Nov 2009 18:41:49 +0530

> Herein attached patches to support dhcp based provisioning for iSCSI
> offload capable cards. I have made dhcp code as generic as possible,
> please go through the code. Based on the feedback I will submit final
> version of these patches.

You can't really add objects to the build before the patch that
adds the source for that object.

