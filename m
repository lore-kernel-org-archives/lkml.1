Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYIQP2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYIQP2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYIQP2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:28:30 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:32990 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbYIQP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:28:29 -0400
Message-ID: <48D1221B.1000601@lwfinger.net>
Date: Wed, 17 Sep 2008 10:28:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Michael Buesch <mb@bu3sch.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <200809171622.55882.mb@bu3sch.de> <20080917145007.GA5186@khazad-dum.debian.net>
In-Reply-To: <20080917145007.GA5186@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> He means rfkill_force_state() should change the LED state in the process,
> which it isn't doing.
> 
> It is an one-line patch, I am testing it now.
> 

If your one-line patch fixes my regression, then I'll ACK it for 2.6.27.

Larry
