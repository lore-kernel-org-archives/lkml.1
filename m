Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXD0AXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXD0AXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXD0AXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:23:20 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:4392 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbXD0AXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:23:19 -0400
Date: Fri, 27 Apr 2007 02:23:18 +0200
From: Olivier Galibert <galibert@pobox.com>
To: David Lang <david.lang@digitalinsight.com>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070427002318.GB11265@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	David Lang <david.lang@digitalinsight.com>,
	Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <20070426224256.GB21926@elf.ucw.cz> <Pine.LNX.4.63.0704261520350.9674@qynat.qvtvafvgr.pbz> <20070426231228.GI21695@elf.ucw.cz> <Pine.LNX.4.63.0704261545100.9674@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704261545100.9674@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 03:49:51PM -0700, David Lang wrote:
> swap partitions are limited to 2G (or at least they were a couple of months 
> ago when I last checked). I also don't want to run the risk of having a box 
> try to _use_ 16G worth of swap. I'd rather have the box hit OOM first.

They aren't limited anymore, I have a number of machines with 20G swap
for experiments.

  OG.

