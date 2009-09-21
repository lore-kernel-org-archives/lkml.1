Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZIUHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZIUHf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZIUHf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:35:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:55136 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751988AbZIUHf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:35:27 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18futJ6CUUf2lnrpcjirzFAlBorWTPw0pweIZMgyP
	L449yLs0bwgyNX
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: ThinkPad T400 and the mute button ...
Date: Mon, 21 Sep 2009 09:35:28 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909210935.29280.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It works - but only if the T400 is plugged into the docking station. Then both
the mute button at the T400 and the button of the external keyboard works fine.
However w/o the docking station pressing the mute button of the T400
gives under KDE the graphical response "mute on" - but that's all, the sound
isn't muted.

Is this behaviour known/expected or worth a bug report ?

BTW the BIOS is at the latest level (I hoped to avoid the command line 
eboot=pci w/ the new BIOS but no chance, that parameter is necessary to avoid
an extra wait of about 10 seconds during reboot). OTOH the Intel Management
Extension is way older but I'd like to avoid updating it.

-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

