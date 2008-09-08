Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYIHEIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYIHEIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 00:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYIHEIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 00:08:48 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:58421 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYIHEIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 00:08:47 -0400
Message-ID: <17946.166.70.238.45.1220845139.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 7 Sep 2008 21:38:59 -0600 (MDT)
Subject: [ANNOUNCE] Merkey's LinuxWare 1.0 MS-DOS Loader
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am pleased to announce the release of Merkey's LinuxWare, an MS-DOS (or
DR-DOS) loader that allows you to compile a Linux kernel as an MS-DOS
Executable, boot and load Linux from MS-DOS (while DOS stays resident).

This in essence is exactly the same as old Legacy Netware, and in fact, I
wrote a linker that does what the old NetWare custom linker did when it 
compiled the NetWare kernel and linked it as a DOS Application.  Linux
works
just like it does normally, except you can quit Linux and exit back to  DOS.


Now who in the hell would want this?  Well, it's damn convenient to have  
(or was at one time) a DOS loadable program.

One cool thing inside LinuxWare is the loader debugger which is able to 
initialize the kallsyms tables BEFORE LINUX IS LOADED and allow you to
walk through early loader init of Linux (like where it loads the GDT for
the first time).

So there is a lot of cool, innovative (not boring) and powerful code
within, that can be used to make it easier to debug and develop linux. 
This tool was designed by me (and used by me) to take Linux apart and
study it thoroughly, and to shore up a sagging (and now deceased) DR-DOS
market.

I stopped using it after 2.6 so its only up to 2.4.18, and there is an
early MDB integrated with KDB.

BORLAND compiler was used to build the DOS side, but DJGPP would probably
still work.   As part of a lawsuit settlement, this code and IP reverted
back to my ownsership, and since its dead as a doornail DOS, might as well
see if there's stuff in here folks might could salvage -- one man's trash,
another man's treasure ...

ftp://ftp.wolfmountaingroup.org/pub/linuxware/linuxware-09072008.tar.gz
ftp://ftp.wolfmountaingroup.org/pub/linuxware
http://www.wolfmountaingroup.org/

Jeff


FAQ.

So why would someone as hated as you even want to work on Linux?   A. 
It's a free country.   I have some good stuff that helps people, so why
the hell not.  Who made you people god (with a small g) anyway?

So why are you acting like an arrogant, self promoting prick in naming all
this stuff after you -- geez.

A.  Linus = Linux, Reiser = ReiserFS, why the hell not.  everyone else is
doing it.  If Hans and Linus get to do it, so do I !!!!

Isn't Linus and the Linux community opposed to your work in several areas,
like another OS and some of your public anti-linux statements?

A.  I have no idea.  I do it because I enjoy it and it helps a lot of
folks, me included.  I ignore most of what is said on the internet.  When
people say or write something about you, it's not a reflection on you, its
a reflection on them ...'   The same applies to this big mouth on this
end.














