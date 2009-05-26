Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbZEZJbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbZEZJbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZEZJa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:30:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59814
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402AbZEZJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:30:56 -0400
Date: Tue, 26 May 2009 02:30:55 -0700 (PDT)
Message-Id: <20090526.023055.41899055.davem@davemloft.net>
To: kay.sievers@vrfy.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sparc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <ac3eb2510905220442n4a1c087nba2ab54a2fba360c@mail.gmail.com>
References: <1239898912.17211.7.camel@poy>
	<20090416.155643.06066521.davem@davemloft.net>
	<ac3eb2510905220442n4a1c087nba2ab54a2fba360c@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 22 May 2009 13:42:42 +0200

> just a quick check, to make sure we are prepared when 2.6.31 opens.
> Any updates regarding the BUS_ID_SIZE conversion?

I have a nearly completed patch and will make sure it gets into
2.6.31
