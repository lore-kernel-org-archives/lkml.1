Return-Path: <linux-kernel-owner+w=401wt.eu-S966841AbXEGVhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966841AbXEGVhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966516AbXEGVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:36:57 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38902 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966341AbXEGVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:36:56 -0400
Date: Mon, 7 May 2007 23:36:44 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: =?ISO-8859-1?Q?No=E8l_K=F6the?= <noel@debian.org>
cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel option CONFIG_USB_HIDINPUT_POWERBOOK description
 update
In-Reply-To: <1178565441.4813.22.camel@mbp.domain.lan>
Message-ID: <Pine.LNX.4.64.0705072335590.16923@twin.jikos.cz>
References: <1178118015.4820.26.camel@mbp.domain.lan> 
 <Pine.LNX.4.64.0705030951520.16923@twin.jikos.cz> <1178565441.4813.22.camel@mbp.domain.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-314098766-1178573804=:16923"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-314098766-1178573804=:16923
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 7 May 2007, No?l K=F6the wrote:

> > >  config USB_HIDINPUT_POWERBOOK
> > > -       bool "Enable support for iBook/PowerBook special keys"
> > > +       bool "Enable support for iBook/PowerBook/MacBook/MacBookPro s=
pecial keys"
> > I will apply this into my tree, thanks.
> Great thanks. Does this mean it will go into your tree and then into the
> mainline kernel, or is there an additional step needed?

No further steps needed on your side. Applied, thanks,

--=20
Jiri Kosina
---1747641777-314098766-1178573804=:16923--
