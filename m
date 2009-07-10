Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZGJKor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZGJKor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZGJKoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:44:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZGJKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:44:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH] score: add regsets support for score
Date: Fri, 10 Jul 2009 12:44:28 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
References: <OF46A53443.CAD32185-ON482575EF.0034F550-482575EF.0035E714@sunplusct.com>
In-Reply-To: <OF46A53443.CAD32185-ON482575EF.0034F550-482575EF.0035E714@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?gb2312?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2E?=
 =?gb2312?q?a=5E3zb?=)
 =?gb2312?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?gb2312?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Message-Id: <200907101244.28829.arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/9kdvxqPYyT07wT+ZqLmnbimGvk3Enr9Glljx
 y2av7fp+0J+Js1wXPTl5cNm9qTmrNfP3YWE7dI3w9oPNupieX7
 NM0EgrDXJwGDy3RPtRH5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-07-09 23:08:54:
> 
> > You still use an email client that breaks patches by adding line-wraps.
> > Please use a different mail client for sending patches. You could for
> > example use git-send-email with a random freemail account and still
> > set your corporate sender address.
> 
> Sorry, our MIS haven't solved this problem yet,
> I have to used it until they fixed this bug.

What's the problem? Do you need a development machine with SMTP access to
the internet? If so, the easiest way would be to use master.kernel.org
once you have an account there and not rely on your company infrastructure.

I noticed that you have started using Thunderbird instead of Notes now.
While Thunderbird has the same bug, you can at least work around it,
see the section on thunderbird in
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/email-clients.txt

OTOH, if you got thunderbird to send out your mails, you should
also be able to send out using git-send-email on the same server,
without any help from your MIS.

	Arnd <><
