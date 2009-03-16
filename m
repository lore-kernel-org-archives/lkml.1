Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZCPQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZCPQCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZCPQCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:02:12 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41013 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbZCPQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:02:10 -0400
Date: Mon, 16 Mar 2009 17:02:08 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090316160208.GB4458@rhlx01.hs-esslingen.de>
References: <s5hy6z9i44h.wl%tiwai@suse.de> <20090315092117.GA1567@rhlx01.hs-esslingen.de> <20090316120312.GA19299@rhlx01.hs-esslingen.de> <s5hocw1r7n5.wl%tiwai@suse.de> <20090316133001.GA8437@rhlx01.hs-esslingen.de> <s5hfxhdr1oz.wl%tiwai@suse.de> <20090316143158.GA12725@rhlx01.hs-esslingen.de> <s5hab7lr0k1.wl%tiwai@suse.de> <20090316145036.GA26358@rhlx01.hs-esslingen.de> <s5h4oxtqy6q.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4oxtqy6q.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 16, 2009 at 04:34:05PM +0100, Takashi Iwai wrote:
> At Mon, 16 Mar 2009 15:50:36 +0100,
> Andreas Mohr wrote:
> > In the problematic case (using plughw),
> > whenever left channel / right channel sliders are equal, no sound gets recorded.
> 
> What are "sliders"?

Umm, volume level controls.

Andreas
