Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZCWThj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZCWThj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbZCWTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:37:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZCWTh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:37:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 44/57] microblaze_v7: termbits.h termios.h
Date: Mon, 23 Mar 2009 20:37:23 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <7342f6af4eb95f5bc2cd89a196ab33a3ddc4d5c1.1237407249.git.monstr@monstr.eu> <46a9b066a95fad763f6c12044dbc3cd580681fb9.1237407249.git.monstr@monstr.eu>
In-Reply-To: <46a9b066a95fad763f6c12044dbc3cd580681fb9.1237407249.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903232037.23768.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/7EKC7g1SsgJIvb7v25Zmj4fxVZLlVp1osDaa
 yFGOyACbf09s/JkJdUEPOB1EcCFsVx+VdQpHh3OAQMxwzBmbQ9
 1f6+lMy1KAn2dzzJAByUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/include/asm/termbits.h |  203 ++++++++++++++++++++++++++++++++
>  arch/microblaze/include/asm/termios.h  |   88 ++++++++++++++
>  2 files changed, 291 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/include/asm/termbits.h
>  create mode 100644 arch/microblaze/include/asm/termios.h

Did you take at the header files I have in git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/#generic-headers?

I haven't gotten around to posting them for review, but I still think
it would be great if we can at least make sure they are identical
so we can remove your versions as soon as we have the asm-generic ones.

	Arnd <><
