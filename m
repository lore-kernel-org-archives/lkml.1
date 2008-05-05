Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYEETee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYEETee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYEETeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:34:25 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:49780 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYEETeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:34:24 -0400
Date: Mon, 5 May 2008 21:28:31 +0200
From: FD Cami <francois.cami@free.fr>
To: "Kevin Burton" <burtonator@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
Message-ID: <20080505212831.22371732@olorin>
In-Reply-To: <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	<20080505131607.5556b1f2@olorin>
	<30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 11:34:24 -0700
"Kevin Burton" <burtonator@gmail.com> wrote:

> >> In the mean time is it possible to disable the page cache or limit it
> >> to say 10% of system memory?
> >
> > You might want to look at /proc/sys/vm/ for tunables.
> > /proc/sys/vm/vfs_cache_pressure and /proc/sys/vm/swappiness are probably
> > what you are looking for.
> 
> I haven't played with vfs_cache_pressure so I'll take a look at this.
> 
> Unfortunately, swappiness doesn't work as intended.

Could you explain the original problem ? That way we might help you better.

Best,

Francois
