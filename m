Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXFYNVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXFYNVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXFYNVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:21:22 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:37657 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbXFYNVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:21:21 -0400
Message-ID: <467FC143.4040906@mandic.com.br>
Date: Mon, 25 Jun 2007 10:21:07 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K³oczko wrote:
> ALSA still does not provides good soud devices virtualization for more 
> then one application. Each day I'm using bludy words when I'm try to use 
> skype which oppens /dev/mixer after run galeon with flash plugin which 
> opens /dev/snd/pcm* or when I start GNOME session with soud enabled 
> (handled by esd whuich uses ALSA).


Install alsa-oss fix this problem?
<http://www.skype.com/help/guides/soundsetup_linux.html>

Best regards,
Renato
