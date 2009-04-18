Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZDRIz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZDRIz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZDRIzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:55:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59567
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbZDRIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:55:50 -0400
Date: Sat, 18 Apr 2009 01:55:41 -0700 (PDT)
Message-Id: <20090418.015541.05303908.davem@davemloft.net>
To: g.liakhovetski@gmx.de
Cc: florian@openwrt.org, peter@holik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0904172102300.5119@axis700.grange>
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
	<200904171632.26091.florian@openwrt.org>
	<Pine.LNX.4.64.0904172102300.5119@axis700.grange>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Fri, 17 Apr 2009 21:07:52 +0200 (CEST)

> FWIW, I think it's pretty common to name static functions in a .c file, 
> which perform auxiliary function, not really specific to the context 
> without the respective context-prefix.

I'll remember to think of you next time I run grep on the tree.
