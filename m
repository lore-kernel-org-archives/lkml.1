Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXIOI0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXIOI0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXIOI01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:26:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33249 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXIOI00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:26:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EB9703.70705@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 10:25:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: Adrian Bunk <bunk@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rol@witbe.net
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com>	<p73fy1p9m57.fsf@bingen.suse.de>	<1189371621.3526.28.camel@localhost.localdomain>	<20070909210329.GE25798@one.firstfloor.org>	<46E46190.6080607@garzik.org>	<20070912224655.GC3563@stusta.de>	<46EAA08F.30703@s5r6.in-berlin.de>	<20070914151522.GL3563@stusta.de> <20070915080448.37457dcf@tux.DEF.witbe.net>
In-Reply-To: <20070915080448.37457dcf@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> getting too much of "No help text available"
> usually results in people no more reading the help text.

I assert that a Kconfig prompt (a visible Kconfig variable) _without_
help text is a bug.
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
