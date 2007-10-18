Return-Path: <linux-kernel-owner+w=401wt.eu-S1763929AbXJRLuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763929AbXJRLuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761732AbXJRLuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:50:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:54324 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750731AbXJRLup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:50:45 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+NX4QbzmuN82kfM/H4kfh49HDzL4pVKpAVK/4oa1
	GgCPoawfowgH8A
From: Jan-Simon =?iso-8859-15?q?M=F6ller?= <dl9pf@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] hda-intel: no soundcard with current linus' =?iso-8859-15?q?git=09tree?=
Date: Thu, 18 Oct 2007 13:50:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <471538C2.80806@m3y3r.de> <200710181049.48896.dl9pf@gmx.de> <s5hhcko2668.wl%tiwai@suse.de>
In-Reply-To: <s5hhcko2668.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181350.48974.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, it's not called as "working".  You did some workaround
> explicitly...
True ;) .

> > Now it doesn't work, even with other model-options (fujitsu, laptop).
>
> There is no recent change regarding Conexant codecs over months in
> ALSA tree.  So, the problem has to be there for long time.
>
> I guess you didn't take ALSA codes from alsa.git properly?  alsa.git
> master is as same as Linus tree.  The latest ALSA code is hold in mm
> branch.

Aaah ;)  switched to -mm and just compiling ...

Greets
Jan-Simon
