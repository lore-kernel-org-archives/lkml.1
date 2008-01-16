Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYAPGxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYAPGxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 01:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYAPGxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 01:53:11 -0500
Received: from mailout02.sul.t-online.de ([194.25.134.17]:43111 "EHLO
	mailout02.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbYAPGxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 01:53:10 -0500
Message-ID: <478DA9CC.5060406@t-online.de>
Date: Wed, 16 Jan 2008 07:53:00 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
References: <4782833D.3010600@t-online.de>	<s5h3at8rd9c.wl%tiwai@suse.de>	<4783AC7C.50900@t-online.de> <s5h63y42oy6.wl%tiwai@suse.de>
In-Reply-To: <s5h63y42oy6.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: XLW7K0ZBZhuycLL9K2q4NKzkk3XbWOf9JQBIZC5WVzXfE6ve68z4TmMkJ3TKMYawuc
X-TOI-MSGID: b8342721-e26c-4225-8ab1-b9b61f08615a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> Linus, please revert the commit 57a04513cb3 as now.
> The life can go well without this patch.
> 

hda_intel.c works for me in rc8.


Many thanx to all

Harri

