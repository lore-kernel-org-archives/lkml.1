Return-Path: <linux-kernel-owner+w=401wt.eu-S935588AbXFFTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935588AbXFFTW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935381AbXFFTT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:19:59 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:58915 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935472AbXFFTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:19:56 -0400
Date: Wed, 6 Jun 2007 21:21:08 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070606192106.GB6497@enneenne.com>
References: <20070530165705.GD29337@enneenne.com> <4662AE11.70107@drzeus.cx> <20070603145529.GC3879@enneenne.com> <4666F7A1.6030202@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4666F7A1.6030202@drzeus.cx>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: mmc0: unrecognised SCR structure version 1
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 08:06:25PM +0200, Pierre Ossman wrote:
> 
> I'm afraid I have little experience with PXA. Perhaps you can find
> someone on the linux arm kernel mailing list with more insight?

I already asked for.

> Sounds like a fairly common card. Cards so broken that they give an
> incorrect scr version should be rare, so I would guess that there is
> some transfer problem with the PXA. I don't suppose you have any other
> linux based platforms to test the card in?

Unluckily not! :'(

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
