Return-Path: <linux-kernel-owner+w=401wt.eu-S1764992AbXHXVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764992AbXHXVmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763361AbXHXVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:41:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44108
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762321AbXHXVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:41:54 -0400
Date: Fri, 24 Aug 2007 14:41:53 -0700 (PDT)
Message-Id: <20070824.144153.48812936.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       parisc-linux@parisc-linux.org
Subject: Re: errno codes intertwined
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Fri, 24 Aug 2007 18:24:48 +0200 (CEST)

> So I'm just asking: can I rely on the same errno across Linuxes?
> And should the errno values be fixed up?

You cannot rely on error numbers being the same, every
architecture has something to a few to many differences
in this area.

