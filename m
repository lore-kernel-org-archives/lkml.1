Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXBZTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXBZTMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030475AbXBZTMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:12:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33308
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030472AbXBZTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:12:21 -0500
Date: Mon, 26 Feb 2007 11:12:19 -0800 (PST)
Message-Id: <20070226.111219.41878241.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] sparc64: fix CONFIG_PCI_MSI=n compile
 failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702261854.l1QIs8D9013016@alkaid.it.uu.se>
References: <200702261854.l1QIs8D9013016@alkaid.it.uu.se>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 26 Feb 2007 19:54:08 +0100 (MET)

> 2.6.21-rc1 fails to build on sparc64 when CONFIG_PCI_MSI=n:

This is already fixed in my sparc-2.6 GIT tree as of a few
days ago, I'll push the fix to Linus later today.
