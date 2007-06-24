Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbXFXVai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbXFXVai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbXFXV33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:29:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbXFXV3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:29:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: sky2 crash on suspend to RAM
Date: Sun, 24 Jun 2007 22:53:21 +0200
User-Agent: KMail/1.9.5
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       shemminger@osdl.org
References: <467AC01E.4020503@mandic.com.br>
In-Reply-To: <467AC01E.4020503@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706242253.21496.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 June 2007 20:14, Renato S. Yamane wrote:
> Hi,
> Suspend to ram work very fine in my Toshiba M45-S355, but when laptop 
> return (from RAM), my network connection crash, and I need unload and 
> load again my sky2 module (using kernel 2.6.21.1).
> 
> My NIC is:
> Marvell Technology Group Ltd. 88E8036 PCI-E Fast Ethernet Controller 
> (rev 10)
> 
> See below my logs when return from ram:

Please file a bug report at http://bugzilla.kernel.org in the
Power Management->Hibernation/Suspend category.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
