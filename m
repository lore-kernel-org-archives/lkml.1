Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbYFCUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbYFCUs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759015AbYFCUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:41:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40942
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759546AbYFCUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:41:51 -0400
Date: Tue, 03 Jun 2008 12:51:17 -0700 (PDT)
Message-Id: <20080603.125117.231936152.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18501.39659.952880.727014@alkaid.it.uu.se>
References: <18500.62552.958244.633204@harpo.it.uu.se>
	<20080603.062253.17158135.davem@davemloft.net>
	<18501.39659.952880.727014@alkaid.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Tue, 3 Jun 2008 21:26:35 +0200

> It's a shame though that a bug fix needs to have such draconian consequences.

I agree, but the way the X server (tried to) work on sparc before
libpciaccess was even more draconian.
