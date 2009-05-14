Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZENMAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZENMAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbZENMAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:00:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZENMAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:00:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Subject: Re: [PATCH 00/27] more non-ABI asm-generic headers
Date: Thu, 14 May 2009 13:59:59 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <200905041632.28026.arnd@arndb.de> <10f740e80905080704q4d2336b2v8ec851d0c87c6cda@mail.gmail.com>
In-Reply-To: <10f740e80905080704q4d2336b2v8ec851d0c87c6cda@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200905141359.59897.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Z/2QhF/F6tCWVV9+brgH3x4QScUUUefNHd+v
 xAUhAHsTPNLfmQRsV+YDJ8aBzQjOE6cBM242AG6xvh2Cn1XElM
 3ayL8MB8/T8Xt895V3ygw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Geert Uytterhoeven wrote:
> On Mon, May 4, 2009 at 16:32, Arnd Bergmann <arnd@arndb.de> wrote:
> > I haven't tried using git send-email yet, because it does not let
> > me inspect mails after changing the headers but before sending
> > them out.
> 
> The --dry-run option is not sufficient for you?

I've now started using git-send-email after yet another screwup
with quilt+kmail. I now played around using '--suppress-cc all' sending
patches to myself and fixed the problems I found there, which gave
me enough confidence in the general procedure.

	Arnd <><
