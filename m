Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbXGWVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbXGWVZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXGWVZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:25:15 -0400
Received: from main.gmane.org ([80.91.229.2]:42390 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbXGWVZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:25:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 1/2] forcedeth: new device ids in pci_ids.h
Date: Mon, 23 Jul 2007 22:23:20 +0100
Organization: Linux Foundation
Message-ID: <20070723222320.33591cda@oldman>
References: <46A3F9A3.10508@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 87.192.216.40
In-Reply-To: <46A3F9A3.10508@nvidia.com>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 20:43:15 -0400
Ayaz Abdulla <aabdulla@nvidia.com> wrote:

> This patch contains new device ids for MCP73 chipset.
> 
> Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
> 

no current practice is to stop cluttering pci_ids.h with specific sub-device id's
and just have the vendor values.

