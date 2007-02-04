Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXBDVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXBDVhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXBDVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:37:36 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:36486 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXBDVhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:37:35 -0500
Date: Sun, 04 Feb 2007 22:37:33 +0100
Message-Id: <1605445807@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First off, compliments to this announcement, I liked it very much!

Some comment regarding those "volunteers, waiting to get some real work" :)

> > OK, but why isn't your army of volunteers fixing them?

> They don't know about them, or they don't have the hardware to test?
> Seriously, let the kernel-janitor's project know about any issues you
> have and they will be glad to jump on it.  Those people are just
> chomping a the bit to do something a bit bigger than "compiler warning
> cleanups" :)

So many times i have seen good ideas brought up, kernel patches being written, posted to lkml, being developed outside mainline for a while and then being forgotten some time later due to lack of energy of some individual to get this into mainline.

If there is an noticeably number of talented programmers (unfortunately, i`m not) , so why not "feeding" them the right way ? Where is those public and transparent and moderated Linux-Kernel "ToDo"- or "Keep an eye on"-list, sorted by priorities, with sort of a "vote for this feature"-button, so those guys have something they can pick up? There is so much great stuff and ideas out there where they could put their work onto or getting involved, it just needs to be found or sort of being "managed" a little bit better.

For myself, i`m waiting for so quite some things to get "one step further", but they are more or less tied to some single individuals, for which you just cannot send some "hey, what`s up with your project"-message every second day. The interest in many nice projects often is quite low and evolution quite slow, but not only because of the fact that they aren`t great, but more because of not getting widely known. It`s not always missing specs, it`s also some missing noise/feedback for different features or missing of some "driving force" to bring things forward. How should one developer know that somebody needs a feature if those who could probably need it don`t request it? Maybe just because of the fact that they even imagine that such feature would be possible ?

Where is those efforts for fixing/integrating fantastic cowloop?
What about badram/badmem patch ?
Compressed Ccaching ?
Somebody helping with development of dm-loop or extend loop.c to support more than 256 devices ?
Replacement of proprietary, unstable and unelegant vmware-lopp for being able to mount vmware .vmdk files ? Internal Spec for this is open, dm-userspace could be some infrastructure for this, but the author seems to have other priorities....
dm-cow, zfs-fuse - anybody ?
Kernel based target for AoE (Ata over Ethernet) ?  (there are two independent implementations, but both got stuck at some early experimental stage) 

Just my 2 cents. 

Roland K.
Sysadmin/System Engineer

ps:
This isn`t meant to criticise any of you kernel developers since you`re doing fantastic work!


_______________________________________________________________________
Viren-Scan für Ihren PC! Jetzt für jeden. Sofort, online und kostenlos.
Gleich testen! http://www.pc-sicherheit.web.de/freescan/?mc=022222

