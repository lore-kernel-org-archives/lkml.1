Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYAQWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYAQWCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYAQWC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:02:26 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37727 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbYAQWCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:02:25 -0500
X-Sasl-enc: kg2vF+ltwACFiO1yH0ovLmOBLt/GIMzpl4/CVB9s54th 1200607344
Date: Thu, 17 Jan 2008 20:02:19 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080117220219.GA22980@khazad-dum.debian.net>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz> <20080117203416.GK23696@does.not.exist> <20080117211205.GE8953@1wt.eu> <20080117214755.GB28233@does.not.exist> <20080117213225.GF8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117213225.GF8953@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Willy Tarreau wrote:
> On Thu, Jan 17, 2008 at 11:47:55PM +0200, Adrian Bunk wrote:
> > On Thu, Jan 17, 2008 at 10:12:05PM +0100, Willy Tarreau wrote:
> > > On Thu, Jan 17, 2008 at 10:34:16PM +0200, Adrian Bunk wrote:
> > > > do you insist on hearing the truth ("Sorry, I forgot to push."), or can 
> > > > I tell you "I just wanted to see whether anyone notices." instead?  ;-)
> > > 
> > > :-)
> > > 
> > > I think we should intentionally do this test once in a while. Two days
> > > ago I was informed that 2.6.20.21 (the latest 2.6.20 I pushed 3 months
> > > ago) was not clonable nor pullable due to a problem with the HEAD
> > > pointing to latest tag instead of latest commit. Since the error was
> > > also present in my local tree, I'm certain that it remained there
> > > unnoticed for 3 months !
> > 
> > According to git [1] Ralf merged 2.6.20.21 on 2007-10-18 into the 2.6.20 
> > branch of his mips tree, so it must have been somehow possible...
> 
> Maybe he did this locally (Linus showed me that local FS cloning disables
> a lot of tests). Or maybe it could work for some pulls :-/ Definitely a
> weird issue anyway!

Err... I managed to do it for thinkpad-acpi's merge tree too, a lot of time
ago.  So it was somehow possible to get it through the anonymous git server,
probably through the tag.  What I do know is that I usually send head's up
email when I notice something like this, and I find it strange that you
didn't get one from me at that time... but I may have forgotten to send it
at that time.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
