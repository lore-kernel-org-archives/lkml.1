Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbXE2OX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbXE2OX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbXE2OXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:23:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:32813 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbXE2OXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:23:15 -0400
Date: Tue, 29 May 2007 16:34:59 +0200
From: Jan Kara <jack@suse.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       Florin Iucha <florin@iucha.net>, Sam Ravnborg <sam@ravnborg.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [1/4] 2.6.22-rc3: known regressions
Message-ID: <20070529143459.GE25278@duck.suse.cz>
References: <465C2225.2000100@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465C2225.2000100@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Tue 29-05-07 14:52:53, Michal Piotrowski wrote:
> Here is a list of some known regressions in 2.6.22-rc3.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
  <snip>
> File systems
> 
> Subject    : Oops in dentry_iput with 2.6.22-rc2 on AMD64
> References : http://lkml.org/lkml/2007/5/22/4
> Submitter  : Florin Iucha <florin@iucha.net>
> Status     : Unknown
  Actually, the bug seems to be unreproducible and it has probably been a
1-bit flip. So I'd be reluctant to call it a regression...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
