Return-Path: <linux-kernel-owner+w=401wt.eu-S932726AbZGPQWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbZGPQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbZGPQWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:22:11 -0400
Received: from thunk.org ([69.25.196.29]:40364 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718AbZGPQWI (ORCPT <rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 16 Jul 2009 12:22:08 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: PTY bug in 2.6.31-rc3?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1MRTib-0002Cw-T0@closure.thunk.org>
Date: Thu, 16 Jul 2009 12:22:01 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alan,

I'm running 2.6.31-rc3, and twice now over about 36 hours all
pseudo-tty's have stopped working on my system.   Everything else works;
I can fire up gui applications, but starting any new programs that use
pty's will hang.   The only fix seems to be to reboot the system.

I think I remember seeing a similar report, but I thought you said it
had been fixed in -rc3 --- does this ring a bell?

Thanks,

						- Ted
