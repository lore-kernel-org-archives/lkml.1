Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758292AbYERQuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYERQuS (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sun, 18 May 2008 12:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYERQuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:50:00 -0400
Received: from mail.aknet.ru ([78.158.192.26]:55270 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYERQt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:49:59 -0400
Message-ID: <48305E2C.3070303@aknet.ru>
Date: Sun, 18 May 2008 20:49:48 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
        LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [patch] snd-pcsp: silent misleading warning
References: <482737BE.20502@infracom.it>	<4827415A.7060101@aknet.ru>	<482756F0.8020609@infracom.it>	<48275D8D.10500@aknet.ru>	<4827F0A1.9090600@infracom.it>	<48288ACC.1020909@aknet.ru>	<48299F08.2060702@infracom.it>	<4829B6A1.90707@infracom.it>	<s5h7idycfmf.wl%tiwai@suse.de>	<482A7A17.8070706@infracom.it>	<s5hwslxb3t8.wl%tiwai@suse.de>	<482C9A3E.3000009@infracom.it>	<482C9F3E.4050104@aknet.ru>	<482EC93E.7080702@infracom.it>	<482EFED2.1020504@aknet.ru>	<s5hskwgkqe1.wl%tiwai@suse.de>	<48306837.7030505@aknet.ru> <s5hk5hrd1a5.wl%tiwai@suse.de>
In-Reply-To: <s5hk5hrd1a5.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> Well, judging from your previous comment, I thought that it's no sane
> situation for *your* driver.
Only by wrongly triggering a warning
that was supposed for the different
purpose. :)

> But if the driver doesn't care in
> practice, your fix should be fine.  I'll queue it on my tree. 
Thanks.
