Return-Path: <linux-kernel-owner+w=401wt.eu-S965296AbXAYM4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296AbXAYM4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965276AbXAYM4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:56:42 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:53733 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965296AbXAYM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:56:41 -0500
Subject: Re: SATA hotplug from the user side ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070124153727.GC15402@khazad-dum.debian.net>
References: <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com>
	 <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com>
	 <1169456682.2901.18.camel@localhost>
	 <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com>
	 <20070123131040.GB13467@khazad-dum.debian.net> <45B6BF5D.1070300@gmail.com>
	 <1169629789.3779.3.camel@localhost>
	 <20070124153727.GC15402@khazad-dum.debian.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Jan 2007 13:56:23 +0100
Message-Id: <1169729783.18117.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 13:37 -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 24 Jan 2007, Soeren Sonnenburg wrote:
> > might be a good idea to power down the drive using hdparm -Y followed by
> > a scsiadd -r.
[...]
> > the disk or remove the disk from a dm setup). However it is recommended
> > to power down the drive using hdparm -Y followed by a scsiadd -r as
> > stated above. One can validate which disks are attached using ``scsiadd
> 
> Again, this might change soon.

Ok, I think someone more knowledgable than me in this area should do the
final polishing und put it in the docs.

I don't anymore see how/that I can help here.
Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
