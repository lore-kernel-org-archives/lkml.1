Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYBCX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYBCX53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYBCX5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:57:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33847 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753774AbYBCX5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:57:03 -0500
Date: Mon, 4 Feb 2008 00:57:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080203235722.GI2799@elf.ucw.cz>
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz> <200802032333.02821.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802032333.02821.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> - Could the real mode directory be called just "real-mode" or something like
>   this ("rm" is not very meaningful :-))?
> 
> Apart from the above and the _WAKEUP hacks mentioned elsewhere, it looks okay
> (from a very high orbit).

Wakeup hacks? You mean those #ifdef WAKEUP in video code?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
