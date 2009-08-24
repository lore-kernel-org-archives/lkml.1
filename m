Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZHXWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZHXWa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZHXWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:30:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42840
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZHXWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:30:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Mon, 24 Aug 2009 17:30:24 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
References: <20090312092114.GC6949@elf.ucw.cz> <20090824130125.GG23677@mit.edu> <4A92A9F9.10706@gmail.com>
In-Reply-To: <4A92A9F9.10706@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908241730.26356.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009 09:55:53 Artem Bityutskiy wrote:
> Probably, Pavel did too good job in generalizing things, and it could be
> better to make a doc about HDD vs SSD or HDD vs Flash-based-storage.
> Not sure. But the idea to document subtle FS assumption is good, IMO.

The standard procedure for this seems to be to cc: Jonathan Corbet on the 
discussion, make puppy eyes at him, and subscribe to Linux Weekly News.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
