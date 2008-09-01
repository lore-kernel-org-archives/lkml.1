Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYIAJcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYIAJcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYIAJcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:32:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:52375 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753020AbYIAJcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:32:04 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Mon, 01 Sep 2008 11:32:01 +0200
From: qxc@gmx.de
In-Reply-To: <S1753064AbYIAJYb/20080901092431Z+302@vger.kernel.org>
Message-ID: <20080901093201.105550@gmx.net>
MIME-Version: 1.0
References: <S1753064AbYIAJYb/20080901092431Z+302@vger.kernel.org>
Subject: udev and inotify
To: linux-kernel@vger.kernel.org
X-Authenticated: #8043265
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+bvjlrZLibkjeeHYDytPM1VFdArPQWZ8csTT+gQw
 458yXo3Bz641/OOOYYUZBoefaF5vBM7c8NfA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 2fDdIlNfaHItWXvpXCUlnqBiamdhZARS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after I have tried it in different webboards and also in different mailing lists from vger.kernel.org without success I afraid I have to ask my question here (guessing that it is definitely the wrong mailing list):

I have compiled a special kernel without inotify and dnotify because the target system is very static and doesn't needs them (but kernel size is important on that system).

Unfortunately now I get an error message from udev that inotify is missing and therefore udev can't check if its cofiguration files change (what never will happen on that system).

So my question is: how do I get rid of that error message? Can I set a udev option somewhere that turns it off? It is verty irritating for users because it displays an error that is no error...

Thx

Mike

-- 
GMX Kostenlose Spiele: Einfach online spielen und Spaﬂ haben mit Pastry Passion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/6169196
