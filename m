Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbXIOMkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbXIOMkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXIOMkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:40:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:54637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbXIOMkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:40:04 -0400
From: Andreas Schwab <schwab@suse.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Sam Ravnborg <sam@ravnborg.org>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
References: <200709141848.06027.vda.linux@googlemail.com>
	<20070915101811.GA9934@uranus.ravnborg.org>
	<Pine.LNX.4.64.0709151228360.13411@fbirervta.pbzchgretzou.qr>
	<200709151242.38464.vda.linux@googlemail.com>
X-Yow: Why don't you ever enter any CONTESTS, Marvin??
 Don't you know your own ZIPCODE?
Date: Sat, 15 Sep 2007 14:40:02 +0200
In-Reply-To: <200709151242.38464.vda.linux@googlemail.com> (Denys Vlasenko's
	message of "Sat\, 15 Sep 2007 12\:42\:38 +0100")
Message-ID: <jeps0kyue5.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:

> ELF is not as rigid as old a.out (which had only one text, one data
> and one bss segment per .o file IIRC), but size was born in a.out days,
> so it sort of "translates" ELF into a.out.

Try size -A instead.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
