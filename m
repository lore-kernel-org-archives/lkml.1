Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZALXka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZALXka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZALXkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:40:19 -0500
Received: from styx.suse.cz ([82.119.242.94]:55793 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752476AbZALXkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:40:17 -0500
Date: Tue, 13 Jan 2009 00:40:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       trivial@kernel.org
Subject: Re: [PATCH] fix typo "thier" -> "their"
In-Reply-To: <1231799750-21060-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.1.10.0901130039130.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz> <1231799750-21060-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-1210316637-1231803572=:5377"
Content-ID: <alpine.LNX.1.10.0901130039360.5377@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-1210316637-1231803572=:5377
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.1.10.0901130039361.5377@jikos.suse.cz>

On Mon, 12 Jan 2009, Uwe Kleine-König wrote:

> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index c98c31e..a0361ae 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -299,7 +299,7 @@ void sysdev_unregister(struct sys_device * sysdev)
>   *	and the class driver.
>   *
>   *	Note: The list is iterated in reverse order, so that we shut down
> - *	child devices before we shut down thier parents. The list ordering
> + *	child devices before we shut down their parents. The list ordering
>   *	is guaranteed by virtue of the fact that child devices are registered
>   *	after their parents.
>   */

Applied to trivial tree, together with the other four typo patches you 
have sent in this bunch.

Thanks,

-- 
Jiri Kosina
SUSE Labs
--336216065-1210316637-1231803572=:5377--
