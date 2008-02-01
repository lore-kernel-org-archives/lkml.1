Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbYBAKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbYBAKc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYBAKcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:32:45 -0500
Received: from nibbel.kulnet.kuleuven.ac.be ([134.58.240.41]:50341 "EHLO
	nibbel.kulnet.kuleuven.ac.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbYBAKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:32:44 -0500
X-Greylist: delayed 1919 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 05:32:44 EST
Subject: dvb-t bug
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Rik Bobbaers <Rik.Bobbaers@icts.kuleuven.be>
To: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain
Date: Fri, 01 Feb 2008 10:58:16 +0100
Message-Id: <1201859896.6193.10.camel@lois>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-KULeuven-Information: Katholieke Universiteit Leuven
X-KULeuven-Scanned: Found to be clean
X-KULeuven-Envelope-From: rik.bobbaers@icts.kuleuven.be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hey all,

since i'm not completely sure where this bug goes, i'll try lkml and
linux-dvb list.

first of all: my "test" computer is a ubuntu gutsy system (standard) on
a dell latitude D810. the tv card: a Kworld v-stream dvb-t usb2.

the bug: 
http://harry.enzoverder.be/dvb-crash.txt (some irrelevance stripped,
like other boot logs)
http://harry.enzoverder.be/lspci for lspci -vvv output
the kernel/system.map images etc... are trivial i hope...
i'm running this kernel:
Linux version 2.6.22-14-generic (buildd@terranova) (gcc version 4.1.3
20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Tue Dec 18
08:02:57 UTC 2007

i don't know what else i need to provide, but i hope this does the trick
for you guys. if there is anything i can do to help/test/patch/..., let
me know!

i'm not subscribed, so please, include me in replies

thanks dudes!

ps. i used the dvb-usb-adstech-usb2-02.fw firmware. it's VERY hard to
find the firmware... (it's not on linuxtv.org btw) where do you find
firmware?

-- 
harry
aka Rik Bobbaers

K.U.Leuven - LUDIT            -=- Tel: +32 485 52 71 50
Rik.Bobbaers@icts.kuleuven.be -=- http://harry.enzoverder.be

Don't steal - the government hates competition.



Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm

