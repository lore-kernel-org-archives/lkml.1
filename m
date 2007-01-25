Return-Path: <linux-kernel-owner+w=401wt.eu-S1030614AbXAYV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030614AbXAYV4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030616AbXAYV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:56:21 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55548 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030614AbXAYV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:56:20 -0500
X-Sasl-enc: swukRCmGbWnDivuH/ff2Agraj9Ei2mV1OIOA+21PWx1C 1169762178
Date: Thu, 25 Jan 2007 19:56:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
Message-ID: <20070125215611.GB2206@khazad-dum.debian.net>
References: <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost> <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com> <20070123131040.GB13467@khazad-dum.debian.net> <45B6BF5D.1070300@gmail.com> <1169629789.3779.3.camel@localhost> <20070124153727.GC15402@khazad-dum.debian.net> <1169729783.18117.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169729783.18117.7.camel@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Soeren Sonnenburg wrote:
> On Wed, 2007-01-24 at 13:37 -0200, Henrique de Moraes Holschuh wrote:
> > On Wed, 24 Jan 2007, Soeren Sonnenburg wrote:
> > > might be a good idea to power down the drive using hdparm -Y followed by
> > > a scsiadd -r.
> [...]
> > > the disk or remove the disk from a dm setup). However it is recommended
> > > to power down the drive using hdparm -Y followed by a scsiadd -r as
> > > stated above. One can validate which disks are attached using ``scsiadd
> > 
> > Again, this might change soon.
> 
> Ok, I think someone more knowledgable than me in this area should do the
> final polishing und put it in the docs.
> 
> I don't anymore see how/that I can help here.

You did just fine, and in fact your text is 100% correct for 2.6.20 (so it
can be taken asis for 2.6.20, and ammended later when the scsi shutdown
patch gets accepted).

So please don't fell discouraged.  The text is quite good, and if you had
not done it, it wouldn't have been improved anytime soon.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
