Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXBOXoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXBOXoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXBOXoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:44:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbXBOXoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:44:11 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 18:44:11 EST
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: GPL vs non-GPL device drivers
To: v j <vj.linux@gmail.com>, Theodore Tso <tytso@mit.edu>,
       v j <vj.linux@gmail.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 16 Feb 2007 00:40:00 +0100
References: <7OHci-7fx-5@gated-at.bofh.it> <7OHci-7fx-3@gated-at.bofh.it> <7OI8n-fp-11@gated-at.bofh.it> <7OIi9-tI-11@gated-at.bofh.it> <7OS7S-7tW-27@gated-at.bofh.it> <7OTx3-1tH-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HHqCm-0002GX-7Q@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX18CoQUCHr2rcl0DOG1mb8b6sjkrtThgPkGVFfEbYphcGFhXqKuZa6zlnzAjGCXnoESsssTiYQoNSrilJ2fYGIG5YXe8/L9+bhdPYGone8oloQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j <vj.linux@gmail.com> wrote:

> So far I have heard nothing but, "if you don't contribute, screw you."

That's exactly what you tell to the linux community: If they don't contribute
to your project *FOR*NOTHING*IN*RETURN*, you'll punish them by - stamping
your feet, crying out loud and *paying* for another OS. Off cause you are
serious about your rambling - after all, you're no longer spoon-fed for free -
but nobody fears one more small embedded company stuffing their money in
proprietary OS for developement licenses, an extra developement kit, a
royality per device etc.

> All this is fine. Just say so. Make it black and white. Make it
> perfectly clear what is and isn't legal. If we can't load proprietary
> modules, then so be it. It will help everybody if this is out in the
> clear, instead of resorting to stupid half measures like
> EXPORT_SYMBOL_GPL.

You don't have to worry, because your product is based on linux. (I asume,
because if it weren't, you could replace linux by $whatever right now and
be happy, but obviously you aren't happy.) Therefore the GPL license requires
you to release everything under GPL, including your driver. And since your
driver is GPL-ed, you can use GPL symbols.
-- 
"If you see a bomb technician running, follow him."
-U.S.A.F. Ammo Tech Sgt

Friﬂ, Spammer: 3gv@iz6mtCN.7eggert.dyndns.org
