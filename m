Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXJWSZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXJWSZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXJWSZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:25:46 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:59639 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXJWSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:25:45 -0400
Subject: Re: [BUG] rfcomm]
From: Marcel Holtmann <marcel@holtmann.org>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <9e0cf0bf0710231057lf60ce17ldd38489850cdf7c5@mail.gmail.com>
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
	 <9e0cf0bf0710231057lf60ce17ldd38489850cdf7c5@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 20:26:46 +0200
Message-Id: <1193164006.6184.217.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alon,

> > first of all, please check if this still happens with 2.6.23, because we
> > had some patches in the area of the RFCOMM TTY code that might have
> > fixed this.
> 
> These messages are of 2.6.23.

still another one to go :( Anyway since you have experience and you have
a way to reproduce it, please test the latest kernel from Linus' Git
tree.

I can also whip up a patch that disables the device_move() usage and see
if that is the reason for the falling over.

Regards

Marcel


