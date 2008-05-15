Return-Path: <linux-kernel-owner+w=401wt.eu-S1763017AbYEOVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763017AbYEOVIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761645AbYEOVIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:08:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbYEOVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:07:59 -0400
Date: Thu, 15 May 2008 14:07:54 -0700 (PDT)
Message-Id: <20080515.140754.06902962.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18476.33854.71781.133881@harpo.it.uu.se>
References: <18473.60551.911448.98269@alkaid.it.uu.se>
	<20080514.231111.107604885.davem@davemloft.net>
	<18476.33854.71781.133881@harpo.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Thu, 15 May 2008 20:43:10 +0200

> Thanks Dave. As the dmesg diff below shows, this patch fixed
> my lost RAM issue. I actually have about 8KB more available
> now than I had with 2.6.25.

Don't spend it all in one place :-)

> Tested-by: Mikael Pettersson <mikpe@it.uu.se>

Thanks a lot for all of your help.
