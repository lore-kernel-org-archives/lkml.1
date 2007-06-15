Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXFOJHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXFOJHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXFOJGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:06:46 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38237 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXFOJGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:06:44 -0400
Date: Fri, 15 Jun 2007 13:03:57 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 09/18] fs/logfs/gc.c
Message-ID: <20070615090357.GC20361@2ka.mipt.ru>
References: <20070603183845.GA8952@lazybastard.org> <20070603184604.GJ8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070603184604.GJ8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 15 Jun 2007 13:04:15 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 08:46:04PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> --- /dev/null	2007-03-13 19:15:28.862769062 +0100
> +++ linux-2.6.21logfs/fs/logfs/gc.c	2007-06-03 19:18:57.000000000 +0200

Number of bugs in case of error looks quite sad...

-- 
	Evgeniy Polyakov
