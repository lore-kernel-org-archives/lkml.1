Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbYCTWjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbYCTWjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbYCTWjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:39:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53027
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757425AbYCTWjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:39:46 -0400
Date: Thu, 20 Mar 2008 15:39:58 -0700 (PDT)
Message-Id: <20080320.153958.81546591.davem@davemloft.net>
To: xemul@openvz.org
Cc: akpm@linux-foundation.org, tgraf@suug.ch, eparis@parisplace.org,
       dwmw2@infradead.org, viro@zeniv.linux.org.uk, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org, sgrubb@redhat.com, amy.griffis@hp.com
Subject: Re: [PATCH] audit: netlink socket can be auto-bound to pid other
 than current->pid (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E25F7F.5040907@openvz.org>
References: <47E25F7F.5040907@openvz.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>
Date: Thu, 20 Mar 2008 15:58:39 +0300

> This patch is based on the one from Thomas.
 ..
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Acked-by: Eric Paris <eparis@redhat.com>

Applied, thanks everyone.
