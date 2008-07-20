Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYGTWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYGTWCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYGTWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:02:09 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:64768 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbYGTWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:02:08 -0400
X-Greylist: delayed 6888 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 18:02:07 EDT
Date: Sun, 20 Jul 2008 22:06:40 +0200 (CEST)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 17/29] m68k/atari/debug.c: possible cleanups
In-reply-to: <20080717191754.149215226@mail.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
Message-id: <alpine.DEB.1.00.0807202204550.3442@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <20080717191607.955742542@mail.of.borg>
 <20080717191754.149215226@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> - remove the following unused variables:
>  - atari_SCC_init_done

That one I'll need to reintroduce for the SCC driver rewrite (which is 
still stuck in Geert's queue pending cleanups by me).

 	Michael
