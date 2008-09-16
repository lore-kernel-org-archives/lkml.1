Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYIPORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYIPORj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYIPORa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:17:30 -0400
Received: from www.tglx.de ([62.245.132.106]:36211 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYIPOR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:17:29 -0400
Date: Tue, 16 Sep 2008 07:16:24 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <20080915195951.GA1651@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0809160715120.3606@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de>
 <20080914181228.GA18934@elf.ucw.cz> <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de> <20080915091925.GB1787@elf.ucw.cz> <alpine.LFD.1.10.0809150704420.5283@apollo.tec.linutronix.de> <20080915192600.GA1627@elf.ucw.cz>
 <20080915195951.GA1651@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008, Pavel Machek wrote:
> > cg-seek here, and problem is back. Good. I can get the
> > /proc/timer_list ;-)... attached.
> 
> (Actually, timer_list was from more recent kernel, sorry about that, I
> was confused. But I verified, and 72d... is still broken).

Is the timer_list output is from that "sleepy" state ? If not please
provide one.

Thanks,
	tglx
