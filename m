Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYFDDML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYFDDML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYFDDL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:11:57 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51810 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYFDDL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:11:56 -0400
X-Sasl-enc: n0kFD3dWh6eayIGPGtGLYEUcfFmX36ksJgccf8gdf22Q 1212549115
Date: Wed, 4 Jun 2008 00:11:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions (v2)
Message-ID: <20080604031153.GA30067@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805291502.23726.IvDoorn@gmail.com> <20080529162625.GA3375@khazad-dum.debian.net> <200805291919.04384.IvDoorn@gmail.com> <20080529172252.GB3375@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529172252.GB3375@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 29 May 2008, Ivo van Doorn wrote:
> > On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> > > On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > > > This version better documents *_RFKILL_ALL.  Is it good enough for an
> > > > > ACK for patch 14 of 15?
> > > > 
> > > > Yes, you can put my ack on patch 14.
> > > > Thanks for the documentation update. :)
> > > 
> > > Then, this entire batch is ready for merging.  Now, if only Len would
> > > come back from wherever he disappeared to, in order to merge the two
> > > thinkpad-acpi patches, I could send it to netdev for merge.
> > 
> > Actually,  I believe the correct merge order would through wireless-dev,
> > which means the patches should go to John Linville and linux-wireless in the CC.
> 
> Noted.  At merge time (which will be as soon as the thinkpad-acpi
> changes hit mainline), I will send them to you, John, and
> linux-wireless.

I have just done this.  The patchset (with a minor fix to address an
issue sparse found) has been sent to linux-wireless and John Linville
for merging.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
