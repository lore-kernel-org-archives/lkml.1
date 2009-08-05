Return-Path: <linux-kernel-owner+w=401wt.eu-S934666AbZHEQbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934666AbZHEQbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934653AbZHEQbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:31:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53063
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934638AbZHEQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:31:15 -0400
Date: Wed, 05 Aug 2009 09:31:24 -0700 (PDT)
Message-Id: <20090805.093124.170466311.davem@davemloft.net>
To: marcel@holtmann.org
Cc: hidave.darkstar@gmail.com, oliver@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249486555.3094.38.camel@localhost.localdomain>
References: <1249405306.3094.18.camel@localhost.localdomain>
	<a8e1da0908042216u16037395k96cce0746baa504e@mail.gmail.com>
	<1249486555.3094.38.camel@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Wed, 05 Aug 2009 08:35:55 -0700

> Lets me make this perfectly clear here. Bluetooth patches are sent to
> the linux-bluetooth mailing list. There is no need to send them to
> netdev and/or LKML at the same time. Stop this cross-posting. They don't
> get more review there anyway. I take care of sending them for net-2.6
> inclusion if I feel that they are appropriate.

Some of that isn't true, I was reading over his patches as he
posted them.  So cross-posting to netdev is absolutely not a
waste of time IMHO.
