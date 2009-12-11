Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbZLKWUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbZLKWUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761556AbZLKWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:20:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56896
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761537AbZLKWUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:20:10 -0500
Date: Fri, 11 Dec 2009 14:20:16 -0800 (PST)
Message-Id: <20091211.142016.35345283.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-12-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091211193757.GC6663@tuxdriver.com>
References: <20091211193757.GC6663@tuxdriver.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 11 Dec 2009 14:37:57 -0500

> Dave,
> 
> Here is another little batch of fixes intended for 2.6.33.  Most of them
> are tiny.  The rtl8187 led patch is self-contained and squashes a
> warning during suspend.  The regulatory rules update only applies to the
> people _not_ using CRDA, which should be fairly rare nowadays.  But
> still, anyone using that configuration should be working with current
> and safe rules.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
