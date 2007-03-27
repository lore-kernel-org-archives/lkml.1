Return-Path: <linux-kernel-owner+w=401wt.eu-S933934AbXC0CAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbXC0CAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933901AbXC0B74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:59:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35521 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512AbXC0B7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:59:40 -0400
Date: Tue, 27 Mar 2007 03:59:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CIJOML <cijoml@volny.cz>, v4l-dvb-maintainer@linuxtv.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, perex@suse.cz,
       alsa-devel@alsa-project.org, Tino Keitel <tino.keitel@gmx.de>,
       Marcelo Tosatti <marcelo@kvack.org>, Oliver Neukum <oneukum@suse.de>,
       greg@kroah.com, linux-usb-devel@lists.sourceforge.net
Subject: [3/5] 2.6.21-rc5: known regressions
Message-ID: <20070327015943.GA16477@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : Oops when changing DVB-T adapter
References : http://lkml.org/lkml/2007/3/9/212
Submitter  : CIJOML <cijoml@volny.cz>
Status     : unknown


Subject    : snd_intel8x0: divide error: 0000
References : http://lkml.org/lkml/2007/3/5/252
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Status     : unknown


Subject    : USB: iPod doesn't work  (CONFIG_USB_SUSPEND)
References : http://lkml.org/lkml/2007/3/21/320
Submitter  : Tino Keitel <tino.keitel@gmx.de>
Caused-By  : Marcelo Tosatti <marcelo@kvack.org>
             commit 1d619f128ba911cd3e6d6ad3475f146eb92f5c27
Handled-By : Oliver Neukum <oneukum@suse.de>
Status     : problem is being debuggged


