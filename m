Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbYLHJ5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbYLHJ5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYLHJ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:57:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43509
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbYLHJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:57:20 -0500
Date: Mon, 08 Dec 2008 01:57:21 -0800 (PST)
Message-Id: <20081208.015721.27132571.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: mitake@clustcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ktaka@clustcom.com
Subject: Re: [RFC] New functions to manipulate registers for ethtool
From: David Miller <davem@davemloft.net>
In-Reply-To: <59951.1228728372@turing-police.cc.vt.edu>
References: <58622.1228726903@turing-police.cc.vt.edu>
	<20081208.010634.247305010.davem@davemloft.net>
	<59951.1228728372@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Mon, 08 Dec 2008 04:26:12 -0500

> On Mon, 08 Dec 2008 01:06:34 PST, David Miller said:
> 
> > That's an awful reason to have to two ways of doing the exact same
> > thing from userspace.
> 
> Which is why 'sysctl' and 'echo > /proc/sys/....' both exist, right?

We're essentially getting rid of the former, so your sarcasm was
poorly applied, sorry.
