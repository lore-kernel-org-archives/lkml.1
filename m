Return-Path: <linux-kernel-owner+w=401wt.eu-S1765781AbXJRPFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765781AbXJRPFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764744AbXJRPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:05:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:49248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764500AbXJRPFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:05:17 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19hHAs0RkhhWICNep/YqFwO0ahd9yXsdpLo8xD+Bz
	gdnc1covCqWunp
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] hda-intel: no soundcard with current linus' =?iso-8859-1?q?git=09tree?=
Date: Thu, 18 Oct 2007 17:05:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <471538C2.80806@m3y3r.de> <s5hhcko2668.wl%tiwai@suse.de> <200710181350.48974.dl9pf@gmx.de>
In-Reply-To: <200710181350.48974.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181705.18265.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I compiled some different kernel and tried - no success without module, 
module=fujitsu, module=laptop, model=asus. I went through the alsa doc and 
found the section about Conexant 5047. I tried it and got some sound when 
using module=laptop-hp.

So I suppose some pins are different here.

So let's summarize: I get sound on a 2.6.23 with module=laptop-hp. Laptop is a 
fujitsu-siemens v5505 as mentioned.

Best regards
Jan-Simon


