Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbXLUKMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbXLUKMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbXLUKMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:12:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59462
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbXLUKMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:12:37 -0500
Date: Fri, 21 Dec 2007 02:12:36 -0800 (PST)
Message-Id: <20071221.021236.267832858.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: herbert@gondor.apana.org.au, alan@lxorguk.ukuu.org.uk, joe@perches.com,
       apw@shadowen.org, lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       elendil@planet.nl, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       trivial@kernel.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Fri, 21 Dec 2007 11:10:38 +0100 (CET)

> Can we get back to programming?

Well, the kernel log messages are programs, the kind that are for
humans trying to analyze a problem.
