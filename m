Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbYEOUie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbYEOUie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYEOUi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:38:26 -0400
Received: from mail.aknet.ru ([78.158.192.26]:58741 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbYEOUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:38:25 -0400
Message-ID: <482C9F3E.4050104@aknet.ru>
Date: Fri, 16 May 2008 00:38:22 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
CC: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Non-working snd-pcsp
References: <482737BE.20502@infracom.it>	<4827415A.7060101@aknet.ru>	<482756F0.8020609@infracom.it>	<48275D8D.10500@aknet.ru>	<4827F0A1.9090600@infracom.it>	<48288ACC.1020909@aknet.ru>	<48299F08.2060702@infracom.it>	<4829B6A1.90707@infracom.it>	<s5h7idycfmf.wl%tiwai@suse.de>	<482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de> <482C9A3E.3000009@infracom.it>
In-Reply-To: <482C9A3E.3000009@infracom.it>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Roberto Oppedisano wrote:
> I tried different switch combination with  alsamixer, but no still no
> sound from the speaker...
Both no beeps and no PCM?
Please show us your current full
mixer config again.
Please don't forget to try the
options snd-pcsp nforce_wa=1
too.

> (I managed to enable the speaker, following Stas suggestion)
With the master volume at maximum?
Then I am almost out of ideas... :(
