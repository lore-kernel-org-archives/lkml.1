Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbXJRQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbXJRQTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765536AbXJRQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:19:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:38002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933103AbXJRQTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:19:20 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+bVjt/nWGbXv7SxQANGJTnbTBk/WpLNCtHukaodR
	nk9iy7OP1oCLi3
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] hda-intel: no soundcard with current linus' =?iso-8859-1?q?git=09tree?=
Date: Thu, 18 Oct 2007 18:19:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <471538C2.80806@m3y3r.de> <200710181705.18265.dl9pf@gmx.de> <s5hzlygzdu1.wl%tiwai@suse.de>
In-Reply-To: <s5hzlygzdu1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181819.25496.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Tried you patch. Now the card works even without any model selected. Also the 
speakers sound "better" now :D . Bass is nearly too loud.

Tnx for looking into this!
Just on question: is it possible to mute the main speakers when headphones get 
plugged in ? Atm the internal speakers stay on.

Best regards
Jan-Simon
