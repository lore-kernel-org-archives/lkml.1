Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYLPJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYLPJ5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYLPJ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:57:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:57146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYLPJ53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:57:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Date: Tue, 16 Dec 2008 10:57:02 +0100
User-Agent: KMail/1.9.9
Cc: Jennifer Pioch <piochjennifer@googlemail.com>,
       opensolaris-code@opensolaris.org, opensolaris-rfe@opensolaris.org,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <67079b830812150837o12adaa1awe40b0759bbea1f7a@mail.gmail.com> <4946C160.2090505@redhat.com>
In-Reply-To: <4946C160.2090505@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812161057.03025.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+/ANAQ+vizeEfT3qep/qIZHKWeJHWqiaA24En
 eYFwEEQCmc66uEWT3gtg+LNnwJFAp3ei+dTtYJqjH9KTfe+WZj
 AUc6xvm7GbZx6BBDlDxfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2008, Gerd Hoffmann wrote:
> Jennifer Pioch wrote:
> > On 12/12/08, Gerd Hoffmann <kraxel@redhat.com> wrote:
> >> Free- and OpenBSD have it too.  For Solaris I've found a feature request
> >>  only.  Dunno about MacOS/Darwin.  Other un*xes which are important these
> >>  days?
> > 
> > Do you know the ID of the feature request?
> 
> #1167819 @ bugs.opensolaris.org
> 

Looks like they've been working on it for some time:
"Submit Date   25-MAY-1994"!

	Arnd <><
