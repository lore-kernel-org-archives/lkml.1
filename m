Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbXETP4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbXETP4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbXETP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:56:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34162 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbXETPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:55:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46506F7C.30405@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 17:55:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: dan@dennedy.org, Petr Vandrovec <petr@vandrovec.name>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705201703.37561.arnd@arndb.de> <46506912.9020904@s5r6.in-berlin.de> <200705201737.40631.arnd@arndb.de>
In-Reply-To: <200705201737.40631.arnd@arndb.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Sunday 20 May 2007, Stefan Richter wrote:
>> maybe we should change
...
>> struct raw1394_cycle_timer {
...
>> before a libraw1394 with get-cycle-timer support is released.
> 
> Yes, if you still have the chance to change this without breaking
> users, that would be ideal.
> 
> I assume that struct raw1394_iso_packets is already set in stone,
> right? Otherwise it would be good to make that a compatible structure
> as well.

Alas it's a few years too late for raw1394_iso_packets.
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
