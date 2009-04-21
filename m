Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZDUHcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZDUHcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZDUHcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:32:21 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44861 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZDUHcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:32:20 -0400
Date: Tue, 21 Apr 2009 09:32:19 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090421073219.GA5866@dose.home.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <20090420184024.GA10155@dose.home.local> <s5hmyab15bh.wl%tiwai@suse.de> <20090420194659.GA11399@dose.home.local> <s5h8wluinon.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8wluinon.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 07:24:40 +0200, Takashi Iwai wrote:
> The commit is fcad94a4c71c36a05f4d5c6dcb174534b4e0b136:
>     ALSA: hda - Fix the cmd cache keys for amp verbs

Thanks for the reply. However, the patch doesn't work. I just got
distorted sound again.

Regards,
Tino
