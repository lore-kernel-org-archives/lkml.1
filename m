Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYIBCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYIBCk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 22:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYIBCkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 22:40:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41439 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYIBCku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 22:40:50 -0400
Date: Mon, 1 Sep 2008 19:40:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Kconfig cleanup including spelling and grammar
 touchups.
Message-Id: <20080901194031.67b08ef6.randy.dunlap@oracle.com>
In-Reply-To: <20080901211431.767e20af.kernel1@cyberdogtech.com>
References: <1220239702-15688-1-git-send-email-kernel1@cyberdogtech.com>
	<20080831212445.22af3250.randy.dunlap@oracle.com>
	<20080901211431.767e20af.kernel1@cyberdogtech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 21:14:31 -0500 Matt LaPlante wrote:

> +fixes for randy
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> ---
>  arch/arm/mach-omap1/Kconfig          |    2 +-
>  arch/arm/mach-pxa/Kconfig            |    2 +-
>  arch/blackfin/Kconfig                |    6 +++---
>  arch/cris/Kconfig                    |    6 +++---
>  arch/cris/arch-v32/Kconfig           |    2 +-
>  arch/cris/arch-v32/drivers/Kconfig   |    2 +-
>  arch/cris/arch-v32/mach-fs/Kconfig   |    2 +-
>  arch/mips/Kconfig                    |    2 +-
>  arch/powerpc/Kconfig                 |    2 +-
>  arch/powerpc/platforms/Kconfig       |    2 +-
>  arch/powerpc/sysdev/bestcomm/Kconfig |    4 ++--
>  arch/sh/Kconfig                      |    4 ++--
>  arch/x86/Kconfig                     |    4 ++--
>  drivers/ata/Kconfig                  |    2 +-
>  drivers/base/Kconfig                 |    2 +-
>  drivers/gpio/Kconfig                 |    6 +++---
>  drivers/hwmon/Kconfig                |    2 +-
>  drivers/i2c/chips/Kconfig            |    4 ++--
>  drivers/input/Kconfig                |    2 +-
>  drivers/leds/Kconfig                 |    6 +++---
>  drivers/media/dvb/frontends/Kconfig  |    2 +-
>  drivers/misc/Kconfig                 |    8 ++++----
>  drivers/mmc/host/Kconfig             |    2 +-
>  drivers/serial/Kconfig               |    2 +-
>  drivers/usb/core/Kconfig             |    2 +-
>  drivers/usb/serial/Kconfig           |    4 ++--
>  fs/Kconfig                           |    2 +-
>  init/Kconfig                         |    4 ++--
>  net/Kconfig                          |    2 +-
>  net/ipv6/Kconfig                     |   18 +++++++++---------
>  net/mac80211/Kconfig                 |    2 +-
>  net/netfilter/Kconfig                |    2 +-
>  32 files changed, 57 insertions(+), 57 deletions(-)

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
