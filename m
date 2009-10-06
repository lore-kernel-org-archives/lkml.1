Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZJFHzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZJFHzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZJFHzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:55:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:53926 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754854AbZJFHzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:55:22 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19DVCc8YeZDjEnoQ1efheGT4DyXhYVY+CmMKmcttJ
	cfkUHjN+Z7TS/H
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: remaining directory include/asm-x86/ after "make mrproper"
Date: Tue, 6 Oct 2009 09:54:33 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910060954.33523.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if I make "make mrproper; make distclean" within /usr/src/linux-2.6.31.1
I cannot kick of that src dir under Gentoo Linux with "emerge -C" completely
b/c of the remaining directory.
I'm wondering why that directory isn't removed with "make mrproper".

-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

