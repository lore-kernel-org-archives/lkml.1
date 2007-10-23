Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbXJWVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbXJWVyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbXJWVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:54:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbXJWVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:54:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Subject: Re: [BUG] rfcomm]
Date: Wed, 24 Oct 2007 00:10:35 +0200
User-Agent: KMail/1.9.5
Cc: "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
References: <200710231950.31313.alon.barlev@gmail.com> <1193162106.6184.208.camel@violet> <9e0cf0bf0710231057lf60ce17ldd38489850cdf7c5@mail.gmail.com>
In-Reply-To: <9e0cf0bf0710231057lf60ce17ldd38489850cdf7c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240010.35799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 23 October 2007 19:57, Alon Bar-Lev wrote:
> On 10/23/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> > first of all, please check if this still happens with 2.6.23, because we
> > had some patches in the area of the RFCOMM TTY code that might have
> > fixed this.
> 
> These messages are of 2.6.23.
> 
> > Second, can you try without uswsusp or suspend2. Both of
> > them are not upstream and I can't tell how much these would effect this
> > kind of behavior.
> 
> How can I test this without doing suspend?
> uswsusp is not upstream?!?! Rafael?

It is upstream and is supposed to work.

Greetings,
Rafael
