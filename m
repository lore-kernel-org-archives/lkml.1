Return-Path: <linux-kernel-owner+w=401wt.eu-S935003AbXG3O1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935003AbXG3O1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbXG3O12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:27:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:58395 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760619AbXG3O11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:27:27 -0400
Date: Mon, 30 Jul 2007 16:27:25 +0200
From: Karsten Keil <kkeil@suse.de>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/5] Use mutex instead of semaphore in ISDN subsystem common functions
Message-ID: <20070730142725.GA13520@pingi.kke.suse.de>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	kkeil@suse.de, kai.germaschewski@gmx.de,
	isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070729212909.GC3432@traven> <20070729214105.GG3432@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729214105.GG3432@traven>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:41:05PM +0200, Matthias Kaehlcke wrote:
> The ISDN subsystem common functions use a semaphore as mutex. Use the
> mutex API instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 

Acked-by: Karsten Keil <kkeil@suse.de>

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
