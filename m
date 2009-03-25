Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbZCYPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbZCYPm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbZCYPmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:42:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046AbZCYPmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:42:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 01/57] microblaze_v7: Kconfig patches
Date: Wed, 25 Mar 2009 16:42:40 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200903251642.40442.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18SZ6chyG2u5oUtWzq/9PRJ+4iuT/ylsk0RSWy
 vNxEAxetiZkWmkUjmmqncEnkE6iPKEjWaT9DmXw0J6Q1+DXu+M
 iKQXQBtvRU5ADXbUNvnDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/Kconfig                       |  136 +++++++++++++++++++++++++
>  arch/microblaze/Kconfig.debug                 |   26 +++++
>  arch/microblaze/platform/Kconfig.platform     |   85 +++++++++++++++
>  arch/microblaze/platform/generic/Kconfig.auto |   62 +++++++++++
>  4 files changed, 309 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/Kconfig
>  create mode 100644 arch/microblaze/Kconfig.debug
>  create mode 100644 arch/microblaze/platform/Kconfig.platform
>  create mode 100644 arch/microblaze/platform/generic/Kconfig.auto

As a general rule for future updates, you should make sure that
the order of your patches is so that you don't get a broken
version in the middle. In your current series, it's not important,
because nothing works really until all your patches are in there.

	Arnd <><
