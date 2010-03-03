Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0CCQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:04:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36007
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab0CCQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:04:30 -0500
Date: Wed, 03 Mar 2010 08:04:49 -0800 (PST)
Message-Id: <20100303.080449.172546594.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uartlite: Fix build on sparc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <fa686aa41003030751x6fbf4cc2t119f225e31bd45c8@mail.gmail.com>
References: <20100303.025026.243831910.davem@davemloft.net>
	<fa686aa41003030751x6fbf4cc2t119f225e31bd45c8@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Mar 2010 08:51:27 -0700

> Or if you prefer, I could expedite my patch that moves
> of_address_to_resource() into common code (it's currently in my test
> branch).  I wasn't planning to merge it until 2.6.35, but it is pretty
> low risk so I'd be comfortable merging it now.

I prefer if you deal with it this way.
