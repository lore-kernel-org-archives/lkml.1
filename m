Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZCSBvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZCSBvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZCSBv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:51:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754913AbZCSBv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:51:26 -0400
Date: Wed, 18 Mar 2009 18:51:13 -0700 (PDT)
Message-Id: <20090318.185113.256379588.davem@davemloft.net>
To: sgruszka@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Document /proc/sys/net/core/netdev_budget
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090316133633.2df4ed3e@dhcp-lab-109.englab.brq.redhat.com>
References: <20090316133633.2df4ed3e@dhcp-lab-109.englab.brq.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Mon, 16 Mar 2009 13:36:33 +0100

> The NAPI poll parameter netdev_budget is not documented in kernel-docs. Since
> it may have a substantial effect on at least some network loads, it should be.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com> 

Applied, thanks.
