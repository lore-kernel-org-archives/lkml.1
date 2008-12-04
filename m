Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYLDIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYLDIlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLDIlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:41:12 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:35488 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYLDIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:41:10 -0500
Date: Thu, 4 Dec 2008 09:40:13 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Message-ID: <20081204084013.GA24397@gundam.enneenne.com>
References: <1228317711-1311-1-git-send-email-jirislaby@gmail.com> <20081203153537.4504bdd7@lxorguk.ukuu.org.uk> <20081203120643.169baeee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203120643.169baeee.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1 #2] Char: n_tty, include module.h
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:06:43PM -0800, Andrew Morton wrote:
> On Wed, 3 Dec 2008 15:35:37 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > On Wed,  3 Dec 2008 16:21:51 +0100
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> > > Hi,
> > > 
> > > this is a ldisc-n_tty-export-all-n_tty-ldisc-methods.patch fix.
> > 
> > NAK and NAK the patch needing it.
> 
> Late :(
> 
> > Once PPS is in
> 
> PPS can't go in without this?

No, PPS works perfectly without that patch.

> Perhaps I can drop pps-serial-clients-support.patch, dunno.

I think you can drop the last fix.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
