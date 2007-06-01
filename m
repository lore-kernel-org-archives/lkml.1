Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbXFAUtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbXFAUtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763139AbXFAUt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:49:29 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42664
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763052AbXFAUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:49:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
Date: Fri, 1 Jun 2007 22:48:53 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>,
       Toralf =?iso-8859-2?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Thierry Volpiatto <tvolpiatt@neuf.fr>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       Ben Collins <bcollins@ubuntu.com>, linux-wireless@vger.kernel.org,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Gary Zambrano <zambrano@broadcom.com>
References: <46600F1C.5000302@googlemail.com>
In-Reply-To: <46600F1C.5000302@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706012248.53971.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007 14:20:44 Michal Piotrowski wrote:
> Networking
> 
> Subject    : b44: regression in 2.6.22
> References : http://lkml.org/lkml/2007/5/27/108
> Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
> Handled-By : Michael Buesch <mb@bu3sch.de>

Well, it looks like a highres-timers problem or something
like that. So I can't really be handling that, as I have no
clue about this.
I suggest you also add Gary Zambrano <zambrano@broadcom.com>
here, as he is actually the maintainer of b44. Not me.
My role was just helping in debugging the issue, as I know
some details of b44.

> Status     : problem is being debugged



-- 
Greetings Michael.
