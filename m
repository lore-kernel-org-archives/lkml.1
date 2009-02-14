Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZBNWCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZBNWCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZBNWCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:02:40 -0500
Received: from mx0.towertech.it ([213.215.222.73]:41008 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753772AbZBNWCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:02:40 -0500
Date: Sat, 14 Feb 2009 23:02:35 +0100
From: Alessandro Zummo <azummo-lists@towertech.it>
To: Andres Salomon <dilinger@queued.net>
Cc: jordan@cosmicpenguin.net, "David Brownell" <david-b@pacbell.net>,
       linux-geode@lists.infradead.org, dsaxena@laptop.org,
       "=?ISO-8859-1?Q?Mart?= =?ISO-8859-1?Q?in-=C9ric?= Racine" 
	<q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
Message-ID: <20090214230235.5a29487f@i1501.lan.towertech.it>
In-Reply-To: <20090214152719.1baf52cc@ephemeral>
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>
	<20090214152719.1baf52cc@ephemeral>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 15:27:19 -0500
Andres Salomon <dilinger@queued.net> wrote:

> Sorry, I'm just now getting around to looking at this.  Why did we move it
> from cs553x-gpio.c to geode_32.c?  I have a lemote (longsoon-based) which
> uses cs5536:

 I've been suggested to move it within geode_32. the driver is probably
 pretty geode specific anyhow.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

