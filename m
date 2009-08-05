Return-Path: <linux-kernel-owner+w=401wt.eu-S934724AbZHERDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724AbZHERDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934694AbZHERDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:03:41 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51388 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603AbZHERDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:03:40 -0400
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, oliver@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090805.093124.170466311.davem@davemloft.net>
References: <1249405306.3094.18.camel@localhost.localdomain>
	 <a8e1da0908042216u16037395k96cce0746baa504e@mail.gmail.com>
	 <1249486555.3094.38.camel@localhost.localdomain>
	 <20090805.093124.170466311.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 10:03:33 -0700
Message-Id: <1249491813.3094.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > Lets me make this perfectly clear here. Bluetooth patches are sent to
> > the linux-bluetooth mailing list. There is no need to send them to
> > netdev and/or LKML at the same time. Stop this cross-posting. They don't
> > get more review there anyway. I take care of sending them for net-2.6
> > inclusion if I feel that they are appropriate.
> 
> Some of that isn't true, I was reading over his patches as he
> posted them.  So cross-posting to netdev is absolutely not a
> waste of time IMHO.

this is great and netdev might make sense from time to time, but for
sure posting them to LKML is just noise. To be honest, if you wanna read
Bluetooth patches before they are acked by me, you could subscribe to
linux-bluetooth.

Regards

Marcel


