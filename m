Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZCLJfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZCLJfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZCLJe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:34:59 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42808 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZCLJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:34:59 -0400
Message-ID: <49B8D730.4030708@davidnewall.com>
Date: Thu, 12 Mar 2009 20:04:40 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix off-by-one in __iterator_load_balance
References: <49B7CF67.5070604@davidnewall.com>
In-Reply-To: <49B7CF67.5070604@davidnewall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> An off-by-one bug in __iterator_load_balance causes it to erroneously
> return NULL if the next task on the list is also the last entry in the
> list.  This patch corrects that fault.
>   

Patch withdrawn.  Who'd have thought 2.6.27.19 was so out of date?
