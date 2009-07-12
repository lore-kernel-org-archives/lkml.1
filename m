Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZGLPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZGLPH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 11:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZGLPHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 11:07:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZGLPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 11:07:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Sun, 12 Jul 2009 17:07:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090710162105.GA1469@ucw.cz> <4A592C09.8060104@msgid.tls.msk.ru>
In-Reply-To: <4A592C09.8060104@msgid.tls.msk.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907121707.11152.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/rREjVwJ8JNMBPKdc5GHajRuupHi4WlVH1hDn
 RC+hZmqO/HuoUi8Isdnz657N0efOYUZkhmU40sUOpDvq9E2z5i
 3HfTTIbab6RYpw3KylSuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Michael Tokarev wrote:
> As I mentioned in my first email, I'm not the right person to
> do the patch.  But regardless, I spent about a day understanding
> this stuff (or trying to, anyway) - 100% useless day - and when
> I thought I have a patch someone else spoken up and said this
> way (compat_ioctl) is the wrong approach now.  And sent another,
> also trivial patch, adding compat calls right to the proper
> place in kernel/power.c.  Which (the patch) has been ignored
> too.

I never got a reply from you saying whether or not the patch
I sent actually worked. If you or someone else can confirm it,
I'll resend with the fixes you mentioned.

	Arnd <><
