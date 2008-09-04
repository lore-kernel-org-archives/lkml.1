Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYIDKPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYIDKPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbYIDKPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:15:17 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:55127 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671AbYIDKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:15:15 -0400
Date: Thu, 04 Sep 2008 11:32:31 +0200 (CEST)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 5/8] m68k: Remove unused atari_kbd_translate()
In-reply-to: <20080903071742.326285837@mail.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.1.00.0809041121030.12258@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <20080903071542.615137611@mail.of.borg>
 <20080903071742.326285837@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

> From: Geert Uytterhoeven <geert@linux-m68k.org>
>
> If CONFIG_VT=n, I get:
>
> | arch/m68k/atari/built-in.o: In function `atari_kbd_translate':
> | arch/m68k/atari/atakeyb.c:640: undefined reference to `shift_state'
>
> Just remove atari_kbd_translate(), as it's unused.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks for cleaning this up! No need to ack these, is there?

 	Michael

