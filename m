Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbZDGVax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbZDGVax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZDGVan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:30:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZDGVam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:30:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Subject: Re: [Bug #13018] 2.6.29 on MacBook 2,1 fails to reboot
Date: Tue, 7 Apr 2009 23:30:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       mstevens@win-professional.com, Takashi Iwai <tiwai@suse.de>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <9b1675090904061913o614e02fdl22ef2cf795525a6d@mail.gmail.com> <9b1675090904061914m4d5e204lbf726a07ba406cf2@mail.gmail.com>
In-Reply-To: <9b1675090904061914m4d5e204lbf726a07ba406cf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072330.59738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Trenton D. Adams wrote:
> On Mon, Apr 6, 2009 at 8:13 PM, Trenton D. Adams
> <trenton.d.adams@gmail.com> wrote:
> > Hi Rafael,
> >
> > Yes, it is still a problem.  I have identified it as far down to being
> > an alsa problem.  Please follow the other thread related to this.  I
> 
> Oops, sorry, I should make clear that it is not an alsa problem
> specifically, but an alsa hda-intel driver issue, which is related to
> alsa.

OK, thanks for the update.

Rafael
