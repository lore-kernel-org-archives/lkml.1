Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYEDSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYEDSMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYEDSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:11:55 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:59701 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYEDSLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:11:55 -0400
Message-ID: <481DFC5B.1070802@aknet.ru>
Date: Sun, 04 May 2008 22:11:39 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch] build fix for sound/drivers/pcsp/pcsp.c
References: <20080504173740.GA14170@elte.hu>
In-Reply-To: <20080504173740.GA14170@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ingo Molnar wrote:
>   sound/drivers/pcsp/pcsp.c:201: error: implicit declaration of function 'snd_pcm_suspend_all'
There was a fix for that recently.
http://hg-mirror.alsa-project.org/alsa-kernel/rev/84966a18bd41
