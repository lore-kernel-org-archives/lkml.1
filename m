Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbYDKW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbYDKW1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 18:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYDKW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 18:26:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42013
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbYDKW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 18:26:57 -0400
Date: Fri, 11 Apr 2008 15:26:58 -0700 (PDT)
Message-Id: <20080411.152658.233846234.davem@davemloft.net>
To: tilman@imap.cc
Cc: johnpol@2ka.mipt.ru, lkml@rtr.ca, ilpo.jarvinen@helsinki.fi,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FFE33C.1000707@imap.cc>
References: <47FF6555.50004@rtr.ca>
	<20080411143537.GA27874@2ka.mipt.ru>
	<47FFE33C.1000707@imap.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sat, 12 Apr 2008 00:16:28 +0200

> So I was right after all? Bug reports from people who (for whatever
> reason, including having to earn their living) cannot do a bisect are
> not welcome?

You need to qualify this with: when a bisect is asked of them

You seem to be quite eager to harp on this specitic point, to make it
seem as if a bug report is useless if the person cannot or will not
bisect in all cases.  And that simply is not what we are saying here.
