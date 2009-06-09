Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZFIC5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZFIC5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZFIC5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:57:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35385
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbZFIC5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:57:08 -0400
Date: Mon, 08 Jun 2009 19:57:09 -0700 (PDT)
Message-Id: <20090608.195709.158667574.davem@davemloft.net>
To: jonathan@jonmasters.org
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, mjt@tls.msk.ru,
       linux-kernel@vger.kernel.org, romieu@fr.zoreil.com, stable@kernel.org
Subject: Re: [patch] r8169: fix crash when large packets are received
From: David Miller <davem@davemloft.net>
In-Reply-To: <1244511638.30733.41.camel@localhost.localdomain>
References: <4A2D8B8B.80905@gmail.com>
	<1244511638.30733.41.camel@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Masters <jonathan@jonmasters.org>
Date: Mon, 08 Jun 2009 21:40:38 -0400

> CC -stable team - remote DoS with this hardware present.

"remote", if on the same physical subnet, otherwise easily protectable
if not impossible to trigger
