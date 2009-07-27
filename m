Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZG0WXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZG0WXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZG0WXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:23:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZG0WXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:23:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: [Bug #13700] usb error flood in dmesg, makes kde use plenty of cpu - bisected
Date: Tue, 28 Jul 2009 00:24:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       jouni susiluoto <jouni.susiluoto@helsinki.fi>,
       Takashi Iwai <tiwai@suse.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.ejE.GIObKB@chimera> <4A6D3C0F.3050605@pardus.org.tr>
In-Reply-To: <4A6D3C0F.3050605@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907280024.13896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Ozan Çağlayan wrote:
> Rafael J. Wysocki wrote On 26-07-2009 23:28:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13700
> > Subject		: usb error flood in dmesg, makes kde use plenty of cpu - bisected
> > Submitter	: jouni susiluoto <jouni.susiluoto@helsinki.fi>
> > Date		: 2009-07-03 21:13 (24 days old)
> >   
> This is also an issue for 2.6.30 so it should have been listed in the
> other 2.6.29->2.6.30 list I think.

Thanks, updated.

Best,
Rafael
