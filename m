Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZKJNVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZKJNVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZKJNVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:21:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42448 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZKJNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:21:24 -0500
Date: Tue, 10 Nov 2009 14:21:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, zaurus-devel@www.linuxtogo.org
Subject: Re: [RFC PATCH 1/2] power: implement platform battery driver
Message-ID: <20091110132129.GB26144@atrey.karlin.mff.cuni.cz>
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com> <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This driver can be used for dumb batteries when all knowledge about
> their state belongs to the platform that does necessary ADC readings,
> conversions, guessimations etc.
> 
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>


> +++ b/drivers/power/platform_battery.c
> @@ -0,0 +1,119 @@
> +/*
> + * Driver for platform battery
> + *
> + * Copyright (c) Paul Fertser <fercerpav@gmail.com>
> + * Inspired by Balaji Rao <balajirrao@openmoko.org>
> + *
> + * This driver can be used for dumb batteries when all knowledge about
> + * their state belongs to the platform that does necessary ADC readings,
> + * conversions, guessimations etc.
> + *
> + * Use consistent with the GNU GPL is permitted, provided that this
> + * copyright notice is preserved in its entirety in all copies and derived
> + * works.

gpl with additional restrictions? can we get standard gplv2 header?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
