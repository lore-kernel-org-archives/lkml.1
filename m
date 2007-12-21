Return-Path: <linux-kernel-owner+w=401wt.eu-S1763434AbXLUOBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763434AbXLUOBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXLUOB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:01:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754947AbXLUOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:01:26 -0500
Date: Fri, 21 Dec 2007 06:01:25 -0800 (PST)
Message-Id: <20071221.060125.165132180.davem@davemloft.net>
To: david@davidnewall.com
Cc: jengelh@computergmbh.de, herbert@gondor.apana.org.au,
       alan@lxorguk.ukuu.org.uk, joe@perches.com, apw@shadowen.org,
       lizf@cn.fujitsu.com, akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <476BC2EB.3060000@davidnewall.com>
References: <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
	<20071221.021236.267832858.davem@davemloft.net>
	<476BC2EB.3060000@davidnewall.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Newall <david@davidnewall.com>
Date: Sat, 22 Dec 2007 00:13:07 +1030

> David Miller wrote:
> > From: Jan Engelhardt <jengelh@computergmbh.de>
> > Date: Fri, 21 Dec 2007 11:10:38 +0100 (CET)
> >   
> >> Can we get back to programming?
> 
> With respect to the vast majority of log messages, nobody confounded by 
> punctuation is truly trying to analyze a problem!

And nobody confounded by whitespace and coding style is truly
interesting in writing properly functioning code!

I'm going to say it over and over again, everybody who thinks
this issue is different from coding style totally misses the
point.

And everyone who thinks this logging message issue stuff is a
non-issue yet will bash people over the head about coding style in
patch submissions is a hypocrite.
