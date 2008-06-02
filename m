Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYFBUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYFBUGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYFBUGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:06:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53128 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752374AbYFBUGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:06:24 -0400
Date: Mon, 2 Jun 2008 20:43:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] [WATCHDOG] mpc83xx_wdt: fix checkpatch issues
Message-ID: <20080602204318.4cb77070@core>
In-Reply-To: <20080602173836.GA30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
	<20080602173836.GA30705@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 21:38:36 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Quite tired of these warnings ;-), checkpatch spitting them when
> seeing the rename patch.

I've already sent the maintainer a complete overhaul of watchdog via
checkpatch.

Alan
