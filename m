Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXBEBJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXBEBJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 20:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXBEBJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 20:09:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXBEBJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 20:09:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Bcm43xx oops after suspend to disk
Date: Mon, 5 Feb 2007 02:10:05 +0100
User-Agent: KMail/1.9.5
Cc: Larry Finger <larry.finger@lwfinger.net>,
       roucaries bastien <roucaries.bastien@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <45B92488.6090908@lwfinger.net> <195c7a900702040907y8b8eff0gc8b0bbddd79a6792@mail.gmail.com> <45C61B09.7010102@lwfinger.net>
In-Reply-To: <45C61B09.7010102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702050210.06009.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 4 February 2007 18:42, Larry Finger wrote:
> roucaries bastien wrote:
> > 
> > Sorry for the delay it works. This time I can use iwlist eth scan.
> > I have some difficulties to associate and I need to rmmod/modprobe in
> > order to associate but it is another problem linked to a really weak
> > power.
> 
> Bastien,
> 
> Please try this patch instead.

Hm, it doesn't seem to apply to the mainline version of the driver.  Any chance
for a fix against 2.6.20?

Rafael
