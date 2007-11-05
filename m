Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXKEV6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXKEV6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbXKEV55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:57:57 -0500
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:45036 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbXKEV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:57:56 -0500
Date: Mon, 5 Nov 2007 22:57:34 +0100 (CET)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
X-X-Sender: schmitz@zirkon.biophys.uni-duesseldorf.de
To: Adrian Bunk <bunk@kernel.org>
cc: geert@linux-m68k.org, <zippel@linux-m68k.org>,
       <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>
Subject: Re: [2.6 patch] export atari_keyb_init
In-Reply-To: <20071105170819.GE12045@stusta.de>
Message-ID: <Pine.LNX.4.44.0711052251140.20722-100000@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (opal.biophys.uni-duesseldorf.de [134.99.176.7]); Mon, 05 Nov 2007 22:57:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for catching this ...

> This patch fixes the following build error:
>
> <--  snip  -->
>
> ...
>   MODPOST 25 modules
> ERROR: "atari_keyb_init" [drivers/input/mouse/atarimouse.ko] undefined!
> ERROR: "atari_keyb_init" [drivers/input/keyboard/atakbd.ko] undefined!
> make[2]: *** [__modpost] Error 1

Ack, of course...

  Michael


