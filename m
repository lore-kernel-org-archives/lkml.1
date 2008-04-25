Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbYDYI3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbYDYI3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYDYI2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:28:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37844
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbYDYI2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:28:43 -0400
Date: Fri, 25 Apr 2008 01:28:42 -0700 (PDT)
Message-Id: <20080425.012842.239066929.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: shigeonx@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: XTP for 2.6.25
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
References: <18b669d80804240606n47854939x94278f8d974034c1@mail.gmail.com>
	<18b669d80804250059m793f3f56xc4fdb8bad949fa3@mail.gmail.com>
	<Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Fri, 25 Apr 2008 11:23:58 +0300 (EEST)

> Where these results with 2.6.25 as well? ...John Heffner just couple of 
> days ago fixed reordering related problem in TCP (in case that netem 
> parametrization causes reordering), the fix is not even in 2.6.24.y, I 
> think...

Right, I didn't submit it there yet but I will make sure it
hits -stable in the next round.
