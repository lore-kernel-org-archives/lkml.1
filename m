Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYK1M4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYK1M4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYK1M4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:56:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33538 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYK1M4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:56:11 -0500
Date: Fri, 28 Nov 2008 13:56:09 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tejun Heo <tj@kernel.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
In-Reply-To: <492FDDD1.3040209@kernel.org>
Message-ID: <alpine.LNX.1.10.0811281356030.5958@fbirervta.pbzchgretzou.qr>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0811272148490.23969@fbirervta.pbzchgretzou.qr> <492F5613.4090908@kernel.org> <alpine.LNX.1.10.0811281220510.3843@fbirervta.pbzchgretzou.qr>
 <492FDDD1.3040209@kernel.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-11-28 13:02, Tejun Heo wrote:
>Jan Engelhardt wrote:
>>> The devel version of ossp (not out yet, waiting for CUSE and mmap
>>> support merge) can do all the quakes (even the dreaded quake1 which
>>> even ALSA OSS emulation or native OSS can't do because of strict
>>> sample/freq requirement which modern devices don't support anymore)
>> 
>> Quake won't be a problem because its source was released.
>
>Well, it's still nice to just download the stock demo and being able
>to run it.  Has q2 been open sourced too?

Yes and Q3 too.
