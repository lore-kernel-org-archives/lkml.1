Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbXJGUCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbXJGUCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 16:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXJGUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:01:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbXJGUBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:01:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-ide@vger.kernel.org
Subject: Bug #4580: hda: lost interrupt when resuming from S3 - Sony VGN-T1XP
Date: Sun, 7 Oct 2007 22:17:06 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710072217.07656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IDE/ATA wizzards are kindly requested to have a look at:

http://bugzilla.kernel.org/show_bug.cgi?id=4580#c21

as I have no idea of what we can do about the "hard drive password vs suspend"
problem, if anything.

Greetings,
Rafael
