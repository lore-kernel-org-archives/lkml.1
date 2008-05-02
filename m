Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbYEBQ52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbYEBQ52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbYEBQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:57:12 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:58206 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYEBQ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:57:11 -0400
Message-ID: <481B47DC.1010605@aknet.ru>
Date: Fri, 02 May 2008 20:57:00 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru>	<s5hbq42b3j7.wl%tiwai@suse.de>	<480E2EE5.5040208@aknet.ru>	<s5hiqy9dkhv.wl%tiwai@suse.de>	<480F95BE.60109@aknet.ru>	<s5h3apbd1zx.wl%tiwai@suse.de>	<4811555E.3040509@aknet.ru>	<s5hfxta4fem.wl%tiwai@suse.de>	<48120ABF.1050802@aknet.ru>	<s5hve25j2tj.wl%tiwai@suse.de> <s5habj8odtq.wl%tiwai@suse.de>
In-Reply-To: <s5habj8odtq.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
>> The sound subsystem is enabled (loaded) only when necessary.
>> As long as there are many systems without the sound subsystem
>> (i.e. servers), snd-pcsp wouldn't be built (thus not provided even as
>> a module) for their kernels because it prevents input-pcspkr.
> ... and I completely missed the viewpoint of device allocation.
> Yeah, that'll be a bit hackish.
I'll appreciate if your replies
became a bit less cryptic... ;)
What will be a bit hackish?
