Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXEPANd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXEPANd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbXEPANZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:13:25 -0400
Received: from lazybastard.de ([212.112.238.170]:50755 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053AbXEPANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:13:24 -0400
Date: Wed, 16 May 2007 02:09:05 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516000905.GE1220@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <787b0d920705151626x3a11b81csf0f3747a695131b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <787b0d920705151626x3a11b81csf0f3747a695131b0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 19:26:17 -0400, Albert Cahalan wrote:
> 
> Please don't forget the immutable bit. ("man lsattr")
> Having both, BSD-style, would be even better.
> The immutable bit is important for working around
> software bugs and "features" that damage files.
> 
> I also can't find xattr support.

Not forgotten, just on a different list.  Bugs beat features. :)

Jörn

-- 
Data expands to fill the space available for storage.
-- Parkinson's Law
