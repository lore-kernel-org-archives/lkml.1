Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXE3Eeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXE3Eeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXE3Ee0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:34:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47778 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXE3EeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:34:25 -0400
Date: Wed, 30 May 2007 06:35:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       Florin Iucha <florin@iucha.net>, Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [1/4] 2.6.22-rc3: known regressions
Message-ID: <20070530043522.GA11512@uranus.ravnborg.org>
References: <465C2225.2000100@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465C2225.2000100@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 02:52:53PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc3.
> 
> 
> Kbuild
> 
> Subject    : make M=$PWD modules_install does nothing
> References : http://lkml.org/lkml/2007/5/27/190
> Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
> Status     : Unknown
Closed - see http://lkml.org/lkml/2007/5/29/497

	Sam
