Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZJIAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZJIAwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 20:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZJIAw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 20:52:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57986
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbZJIAw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 20:52:27 -0400
Date: Thu, 08 Oct 2009 17:52:22 -0700 (PDT)
Message-Id: <20091008.175222.28610474.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-10-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091008223454.GB2798@tuxdriver.com>
References: <20091008223454.GB2798@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 8 Oct 2009 18:34:54 -0400

> Here is another batch of fixes intended for 2.6.32.  Most of them are
> short, self-contained and more-or-less obvious.  Most of them have been
> baking in -next for several days.
> 
> The b43 patch from Albert Herranz looks big, but most of it is moving a
> structure definition within a header file.  It also changes some DMA
> buffers from stack to heap allocation.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John!
