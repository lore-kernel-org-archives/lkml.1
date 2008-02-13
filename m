Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYBMO4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYBMO4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYBMO4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:56:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbYBMO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:56:44 -0500
Subject: Re: [BUG] snd-hda-intel
From: Peter Zijlstra <peterz@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Jason Gaston <jason.d.gaston@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <s5htzkcsyli.wl%tiwai@suse.de>
References: <1202912714.6811.3.camel@twins> <s5hy79prkqk.wl%tiwai@suse.de>
	 <1202913666.20209.5.camel@lappy>  <s5htzkcsyli.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 15:56:41 +0100
Message-Id: <1202914601.6811.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 15:46 +0100, Takashi Iwai wrote:
> At Wed, 13 Feb 2008 15:41:06 +0100,
> Peter Zijlstra wrote:
> > 
> > >  Is pulseaudio 32bit?
> > 
> > Yes, 32bit userspace.
> 
> One thing forgot to ask:  Can you reproduce the bug with other apps?
> With 64bit apps?

I don't currently have 64bit userland installed, will try to debootstrap
into one soonish.

