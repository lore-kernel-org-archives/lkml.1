Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbZFLIkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbZFLIkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762877AbZFLIkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:40:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835AbZFLIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:40:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] new files form asm-generic
Date: Fri, 12 Jun 2009 10:39:55 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.chen@sunplusct.com>
References: <200906112146.32441.arnd@arndb.de>
In-Reply-To: <200906112146.32441.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906121039.57970.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+SoZN75U+A76zhePmIIPzEM5D729AXYLV8VfR
 478Ng4ploTiHgkCMHqrJ1rDFY9HrCFiqRG5TN9hH96nZU+30zM
 43ZL7kdpwm6Nig8Zab+6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Arnd Bergmann wrote:
> This is a series of patches that adds a mostly-complete set of generic
> header files in the include/asm-generic hierarchy.
> 
> Please pull
> git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/asm-generic.git for-linus
> 

The tree did not merge cleanly as of yesterday because of a conflict with
the perfcounters changes. I pulled the latest linux-2.6.git master
to resolve the conflict.

	Arnd <><
