Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZCYG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZCYG35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 02:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZCYG3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 02:29:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40105
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754600AbZCYG3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 02:29:43 -0400
Date: Tue, 24 Mar 2009 23:29:31 -0700 (PDT)
Message-Id: <20090324.232931.65484505.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, netdev@vger.kernel.org
Subject: Re: [PATCH 15/61] net: struct device - replace bus_id with
 dev_name(), dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1237940825-22904-15-git-send-email-gregkh@suse.de>
References: <20090325001659.GA22461@kroah.com>
	<1237940825-22904-15-git-send-email-gregkh@suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>
Date: Tue, 24 Mar 2009 17:26:19 -0700

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Cc: davem@davemloft.net
> Cc: netdev@vger.kernel.org
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

None of this patch applies to net-next-2.6

Probably because, just like the wimax case, these changes
are already there.
