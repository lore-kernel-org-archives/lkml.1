Return-Path: <linux-kernel-owner+w=401wt.eu-S1764768AbXHIXkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764768AbXHIXkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbXHIXkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:40:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbXHIXkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:40:03 -0400
Date: Thu, 9 Aug 2007 19:40:00 -0400
From: Dave Jones <davej@redhat.com>
To: shacky <shacky83@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unable to handle kernel paging request at virtual address
Message-ID: <20070809234000.GA19549@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	shacky <shacky83@gmail.com>, linux-kernel@vger.kernel.org
References: <7fedbc910708091617o7ae25fd8i36e7ec32c2b9ba86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fedbc910708091617o7ae25fd8i36e7ec32c2b9ba86@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 01:17:14AM +0200, shacky wrote:

 > [87.935473] BUG: unable to handle kernel paging request at virtual
 > address 6d207972
 > [...........] printing eip:
 > [...........] 6d207972
 > [...........] *pde = 00000000
 > [...........] Oops: 000 [#2]
 > [...........] SMP
 > [...........] Modules linked in: bluetooth capability lirc_dev
 > speedstep_lib cpufreq_powersave cpufreq_stats cpufreq_userspace
 > cpufreq_ondemand cpufreq_conservative freq_table video container sbs
 > button dock ac battery ipv6 sbp2 lp fuse snd_emu10k1_synth
 > snd_emux_synth snd_seq_virmidi snd_seq_midi_emul  [....] etc.
 > 
 > I'm using the kernel 2.6.22.
 > 
 > I'm omitting the rest of the error because it is very very long and I
 > have to rewrite it because I can't copy&paste it. If you need some
 > other information please ask. :-)

You snipped the most important part.  Even a digital photo of the
crash would be more useful than what we have above.
So far, there's not really much to go on.

	Dave

-- 
http://www.codemonkey.org.uk
