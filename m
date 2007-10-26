Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbXJZDcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbXJZDcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXJZDcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:32:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXJZDce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:32:34 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
To: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 26 Oct 2007 05:30:58 +0200
References: <9ih2i-qd-15@gated-at.bofh.it> <9ihlw-193-21@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IlFuU-0007ui-WA@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19GMMnP5vuck8lAyRDu9JwrC0Z1kgVuomvACY8
 r6F7gVgGRwfO4MAjwU6+gV077iw0UAbJdM7naWsxV8bf9944ga
 3EsSjmBchldJyX0+RJCjw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> I think the last remaining bit to cleanup is the symlink from
> arch/x86/boot/bzImage.

BTW: Is it useful to have (b)zimage under $ARCH while vmlinux is in the root
dir? (Besides being compatible to external scripts)
-- 
I always tell customers/clients the same thing:
   "Good, Fast, Cheap.  You can pick two."
        -- randem in <slrna09rui.g43.root@jade.randemmedia.com>
Friﬂ, Spammer: 38Ewdi@3.7eggert.dyndns.org mQIC5mdv@t8x8ycg.7eggert.dyndns.org
