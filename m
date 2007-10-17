Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbXJQH0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbXJQH0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXJQHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:25:58 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:32771 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbXJQHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:25:57 -0400
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 03:25:57 EDT
Date: Wed, 17 Oct 2007 09:13:32 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
X-X-Sender: schmitz@zirkon.biophys.uni-duesseldorf.de
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       <linux-input@atrey.karlin.mff.cz>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Atari keyboard: incorporate additional review comments
In-Reply-To: <Pine.LNX.4.64.0710152150260.22973@anakin>
Message-ID: <Pine.LNX.4.44.0710170910430.10134-100000@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (opal.biophys.uni-duesseldorf.de [134.99.176.7]); Wed, 17 Oct 2007 09:13:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Geert Uytterhoeven wrote:

> Atari keyboard: incorporate additional review comments:
>   o Kill reference to source file name
>   o Return error value from input_register_device() instead of -ENOMEM
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>

Ack, Ack  ...

Thanks, Geert! Can't wait to get my Falcon back outta the container ...

	Michael


