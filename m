Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0BNT4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:56:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60165
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017Ab0BNT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:56:38 -0500
Date: Sun, 14 Feb 2010 11:56:52 -0800 (PST)
Message-Id: <20100214.115652.147969784.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-02-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100212214550.GB16783@tuxdriver.com>
References: <20100212214550.GB16783@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 12 Feb 2010 16:45:50 -0500

> Here are a couple of stragglers for 2.6.33.  One purports to fix a
> crash, the other avoids processing of uninitialized data when using
> devices with rate control in hardware.
> 
> The latter patch will cause a merge issue in linux-next.  I'll be happy
> to resolve that in wireless-next-2.6 once this merge request is
> resolved.

Pulled, thanks John.
