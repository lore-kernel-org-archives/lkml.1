Return-Path: <linux-kernel-owner+w=401wt.eu-S1763190AbZCQKi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190AbZCQKi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZCQKis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:38:48 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57670 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZCQKir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:38:47 -0400
Date: Tue, 17 Mar 2009 11:38:45 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Takashi Iwai <tiwai@suse.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090317103845.GA26007@rhlx01.hs-esslingen.de>
References: <s5hprghphid.wl%tiwai@suse.de> <20090316170015.GA9776@rhlx01.hs-esslingen.de> <s5hljr5pex0.wl%tiwai@suse.de> <20090316173000.GA25647@rhlx01.hs-esslingen.de> <s5hiqm9pe1g.wl%tiwai@suse.de> <20090316180638.GB25647@rhlx01.hs-esslingen.de> <s5htz5tyzyg.wl%tiwai@suse.de> <20090316212227.GA29471@rhlx01.hs-esslingen.de> <s5hfxhczinh.wl%tiwai@suse.de> <20090317100500.GA16029@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317100500.GA16029@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 11:05:00AM +0100, Andreas Mohr wrote:
> "Dreamcom 10 Laptop" [7]: " integrated Realtek HD audio processor, two
> built-in Akustica digital microphones and two built-in stereo speakers"
> 
> This was the only reference up and down that I could find to _any_
> notebook's microphone manufacturer listing. I suspect that
> Aspire One has an Akustica microphone array as well since Akustica
> seems to be the leading brand (hmm, any ideas about where the
> second microphone is located if at all existing, but it must exist!!?
> - probably at the front bottom?). 

NOPE. Aspire One most definitely has a Fortemedia SAM (small array
microphone) due to this output:
http://sites.google.com/site/kengell/acer-aspire-one---dmesg

"
...
ForteMedia SAM-Soft Library Loaded!

ALC INIT
...
"

I had already wanted to add the mention of Fortemedia as microphone
manufacturer (forgot this last time), then I researched more and found it.

Fortemedia device names include FM2018-380, not sure yet which one is in
Aspire One.

http://www.fortemedia.com/products/index.htm
( especially http://www.fortemedia.com/products/fm1182.htm )

Andreas
