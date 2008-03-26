Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYCZDFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYCZDFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCZDFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:05:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59523
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYCZDFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:05:06 -0400
Date: Tue, 25 Mar 2008 20:05:01 -0700 (PDT)
Message-Id: <20080325.200501.203623674.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: fhimpe@telenet.be, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6] [TCP]: Must count fack_count also when skipping
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803250942450.14461@kivilampi-30.cs.helsinki.fi>
References: <pan.2008.03.24.20.36.07@telenet.be>
	<20080324.144107.235200795.davem@davemloft.net>
	<Pine.LNX.4.64.0803250942450.14461@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Tue, 25 Mar 2008 23:24:55 +0200 (EET)

> Please don't, it's not the right fix, it fixed a bug that was
> introduced post 2.6.24 by this commit:

Ok.

> Btw, it would have been polite to cc me as well (I suppose you just didn't 
> notice that somebody dropped me in between :-)), not a big prob though as 
> I found it out early anyway because I'm trying to catch up what has been 
> reported against TCP during my week away.

Sorry, my bad.
