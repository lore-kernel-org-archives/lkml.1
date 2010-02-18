Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0BRUd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:33:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0BRUdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:33:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dimitrios Apostolou <jimis@gmx.net>
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258 (fwd)
Date: Thu, 18 Feb 2010 21:34:05 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Wojciech Ploskonka <wploskonka@gmail.com>, thomas@archlinux.org,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> <20100211212415.2eace0c2@infradead.org> <alpine.LNX.2.00.1002182223270.1847@localhost.localdomain>
In-Reply-To: <alpine.LNX.2.00.1002182223270.1847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182134.05648.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 February 2010, Dimitrios Apostolou wrote:
> On Thu, 11 Feb 2010, Arjan van de Ven wrote:
> > On Thu, 11 Feb 2010 22:58:21 +0100
> > Wojciech Ploskonka <wploskonka@gmail.com> wrote:
> >
> >> 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394
> >> Controller (rev 05) (prog-if 10 [OHCI])
> >
> > 08:06.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
> > (rev 05) (prog-if 10 [OHCI])
> >
> > is the one having PME+ set.
> >
> > Len: how do we handle PME's again?
> 
> So is this something fixable? Did I lose some email?

May be fixable at one point in future.

Rafael
