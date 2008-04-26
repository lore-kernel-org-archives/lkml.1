Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYDZKRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYDZKRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 06:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYDZKRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 06:17:04 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38271 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYDZKRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 06:17:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18451.262.785735.187086@harpo.it.uu.se>
Date: Sat, 26 Apr 2008 12:16:38 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Driver for IXP4xx built-in Ethernet ports
In-Reply-To: <20080426092930.GG20657@deprecation.cyrius.com>
References: <m3r6d05ucg.fsf@maximus.localdomain>
	<20080426092930.GG20657@deprecation.cyrius.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr writes:
 > * Krzysztof Halasa <khc@pm.waw.pl> [2008-04-20 19:06]:
 > > Adds a driver for built-in IXP4xx Ethernet ports.
 > 
 > Are there any comments on this driver?  We've been using it for a
 > while now in Debian and it would be great see it in the mainline
 > kernel.

Same here. I've been using it on my IXP42x-based ARM box for
three months now, and it (a) hasn't caused a single problem of
any kind, and (b) is a massive improvement over having to deal
with Intel's IXP400 software and driver kit.
