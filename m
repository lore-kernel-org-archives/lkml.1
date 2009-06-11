Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZFKGrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZFKGrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZFKGrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:47:35 -0400
Received: from mail.uni-paderborn.de ([131.234.142.9]:26102 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbZFKGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:47:35 -0400
Message-ID: <4A30A882.5080206@gmail.com>
Date: Thu, 11 Jun 2009 08:47:30 +0200
From: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090509)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Takashi Iwai <tiwai@suse.de>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
References: <20090610.112804.193703669.davem@davemloft.net>	<4A300B85.2010106@gmail.com> <s5hr5xrvb5m.wl%tiwai@suse.de>
In-Reply-To: <s5hr5xrvb5m.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-IMT-Spam-Score: 0.0 ()
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.6.11.62830
X-IMT-Authenticated-Sender: uid=skoehler,ou=People,o=upb,c=de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai schrieb:
>> I'm also affected by the issue described above.
> 
> Which hardware?

It's a Samsung X20 notebook that has some "SoundMAX" hardware.
I don't know how to describe it better. Does the ALSA driver report,
which ac97 chip is connected?

I'm using the snd_intel8x0 kernel module.

>> Can somebody point out, how I can set this xrun_debug thing or can
>> somebody provide a patch that reverts the change?
> 
> Did you read my reply to David?

I will try, what is described there and I will report back if I get any
debug output.


Regards,
  Sven
