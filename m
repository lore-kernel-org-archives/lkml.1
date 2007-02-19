Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXBSOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXBSOLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBSOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:11:52 -0500
Received: from lazybastard.de ([212.112.238.170]:42207 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXBSOLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:11:51 -0500
Date: Mon, 19 Feb 2007 14:07:02 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Message-ID: <20070219140701.GC5753@lazybastard.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <200702172214.55654.arnd@arndb.de> <20070218020429.GE1038@crusty.rchland.ibm.com> <200702180315.25067.arnd@arndb.de> <20070218030217.GH1038@crusty.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070218030217.GH1038@crusty.rchland.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 February 2007 21:02:17 -0600, Josh Boyer wrote:
> 
> That just sounds like we need Jörn to get off his butt and finish logfs ;)

He's working on it this very moment.  Help in debugging would be
appreciated, if progress is too slow for people.  That part seems to
consume a lot of time and scale fairly well.

Jörn

-- 
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
