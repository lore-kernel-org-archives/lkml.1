Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZFEAC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZFEAC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZFEACU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:02:20 -0400
Received: from elvis.franken.de ([193.175.24.41]:42980 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZFEACU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:02:20 -0400
X-Greylist: delayed 5960 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 20:02:20 EDT
Date: Fri, 5 Jun 2009 00:20:20 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Message-ID: <20090604222020.GA14843@alpha.franken.de>
References: <200906041622.47591.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041622.47591.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:22:46PM +0200, Florian Fainelli wrote:
> We discussed that in private, there are a couple of things
> to fix in order to get 8250 working properly with TI AR7 HW.
> If you can still merge that bit, this would ease future work, thanks !

I still have a tree here, which works without any changes to the 8250
serial driver on a TNETD7300 device.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
