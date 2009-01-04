Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZADRwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZADRwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZADRv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:51:56 -0500
Received: from atoth.sote.hu ([195.111.75.211]:60285 "EHLO atoth.sote.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZADRvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:51:55 -0500
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 12:51:54 EST
Message-ID: <213db97b75b3c08d1a7f9af580563b86.squirrel@atoth.sote.hu>
Date: Sun, 4 Jan 2009 18:34:24 +0100 (CET)
Subject: Re: Grsecurity is about to be discontinued...
From: atoth@atoth.sote.hu
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-List-Milter: non-list mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Reply to Linus Torvalds on Grsecurity:

These days people out there are running closed-source adobe flash plugin
to browse pages like ebay.com where one can come across some applets
causing execution attempts daily. It can be detected using improved
techniques only.
I don't care about what code will run on many noobs' machine, but I'd like
to stay secure. So even if it seems insane, it surely makes sense -
unfortunately.
I suspect some of the most important improvements are labeled "annoying"
by Linus. However some other operating system's board chose to include
parts of such implementations (I won't list them here). It would be good
to see as many snippets of PaX/Grsec in the mainline as possible. Please
take this message as a sign, that Gabor Micsko (trey@hup.hu) is not alone
with his idea.

Grsecurity proved itself as a viable, valuable solution for combined
techniques for hardening Linux. I'm using a laptop which has every
application running regulated by Grsecurity's RBAC system - including
_all_ GUI apps. Please warn me, when there will be some security policies
available to convert a targeted SELinux machine into a fully hardened
SELinux box with GUI.

I'm not sure, that putting Grsecurity in the mainline would save the
project. I rather hope, that some companies using the software will give a
helping hand to the developers. However the Linux community should turn
its attention to defensive security solutions, IMHO. As it gets more and
more abundant, there will be more exploits floating around. Some lessons
can be learned from those "monkeys" on how to think secure.

A polished full-featured security system can raise Linux above other
solutions. The better if there are more possibilities to choose between.
All features of PaX and Grsecurity can be disabled by default: so an
ordinary user shouldn't worry about being secure.

Please consider to think about how secure is your on system and what can
be done to fix it. If some focused persons provide a specialized solution
it worth to be investigated.

Regards,
Dwokfur
-- 
dr Tóth Attila, Radiológus
Attila Toth MD, Radiologist

