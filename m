Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYGAOgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYGAOgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYGAOgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:36:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58516 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbYGAOgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:36:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.26-rc5-git2: snd-emu10k1 does not work
Date: Tue, 1 Jul 2008 16:37:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200806082303.59245.rjw@sisk.pl> <200806302236.45838.rjw@sisk.pl> <20080701032207.GA24719@khazad-dum.debian.net>
In-Reply-To: <20080701032207.GA24719@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011637.33631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Henrique de Moraes Holschuh wrote:
> On Mon, 30 Jun 2008, Rafael J. Wysocki wrote:
> > Still, it's interesting why the openSUSE kernels work with the card without
> > any problems while the kernel.org ones apparently don't.
> 
> Same config?

Certainly not.

> Particularly, same config for CONFIG_SYSFS_DEPRECATED_V2 and 
> other such small details?

Well, in fact I'd like to find the small detail that makes the difference. :-)

Thanks,
Rafael
