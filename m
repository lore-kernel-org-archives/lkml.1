Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYLZJW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYLZJW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYLZJWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:22:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbYLZJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:22:46 -0500
Date: Fri, 26 Dec 2008 01:22:48 -0800 (PST)
Message-Id: <20081226.012248.204332547.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] gigaset: ifdef cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812230927.mBN9ROEn028596@mail.pxnet.com>
References: <20081223-patch-00.tilman@imap.cc>
	<200812230927.mBN9ROEn028596@mail.pxnet.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue, 23 Dec 2008 10:27:24 +0100

> Remove unnecessary #ifdef-s and #if-0-ed code sections.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied.
