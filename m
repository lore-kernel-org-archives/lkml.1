Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYJICnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYJICnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYJICm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:42:57 -0400
Received: from ns.suse.de ([195.135.220.2]:49514 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYJICm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:42:56 -0400
Date: Wed, 8 Oct 2008 19:38:15 -0700
From: Greg KH <gregkh@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Oleksandr Natalenko <pfactum@gmail.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [patch 05/28] ALSA: hda - Fix model for Dell Inspiron 1525
Message-ID: <20081009023815.GA23084@suse.de>
References: <20081006225949.357365087@mini.kroah.org> <20081006231639.GA20567@suse.de> <20081006231708.GF20567@suse.de> <s5h8wt1uey1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8wt1uey1.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 07:55:34AM +0200, Takashi Iwai wrote:
> At Mon, 6 Oct 2008 16:17:08 -0700,
> Greg KH wrote:
> > 
> > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> This patch seems unnecessary for 2.6.25 but only for 2.6.26.
> The original bug reporter (Cc'ed) mentioned that it worked on
> 2.6.25.17.

Thanks, I'll drop it from the .25 queue.

greg k-h
