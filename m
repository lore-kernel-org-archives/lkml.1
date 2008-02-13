Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbYBMOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbYBMOlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYBMOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:41:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58527 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYBMOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:41:10 -0500
Subject: Re: [BUG] snd-hda-intel
From: Peter Zijlstra <peterz@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Jason Gaston <jason.d.gaston@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hy79prkqk.wl%tiwai@suse.de>
References: <1202912714.6811.3.camel@twins>  <s5hy79prkqk.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 15:41:06 +0100
Message-Id: <1202913666.20209.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 15:31 +0100, Takashi Iwai wrote:
> At Wed, 13 Feb 2008 15:25:14 +0100,
> Peter Zijlstra wrote:
> > 
> > lspci -vvv:
> > 
> > 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
> 
> Is this a regression, i.e. did you get similar Oops with previous
> kernels? 

New box, so I have no idea there.

>  Which codec does it have? 

How can I find the answer to that?

>  Is pulseaudio 32bit?

Yes, 32bit userspace.

> Also, build with CONFIG_SND_DEBUG=y.

Sure I'll do.

