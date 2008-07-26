Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYGZHuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYGZHuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYGZHuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:50:01 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:53596 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbYGZHuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:50:00 -0400
Message-ID: <488AD712.1020102@euromail.se>
Date: Sat, 26 Jul 2008 09:49:38 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and	suspend/resume
 serialized
References: <4888311E.9010005@euromail.se> <20080725154250.GA1861@anvil.corenet.prv> <488A1A99.2070609@euromail.se> <20080725143015.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080725143015.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KMeXO-0001kp-9S.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KMeXO-0001kp-9S 250ed7f278e58a0d64b21055a3220e4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

one thing about the drivers/input/mouse/Kconfig patch:

The original version contained "select USB", which was later changed
to "depends on USB" by Andrew Morton. I saw it reappear as "select USB"
in your latest patch, and simply considered it a change back, but
maybe it was an oversight?

Cheers,
Henrik

