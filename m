Return-Path: <linux-kernel-owner+w=401wt.eu-S1763742AbYHDWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763742AbYHDWhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYHDWhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:37:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYHDWhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:37:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Tue, 5 Aug 2008 00:40:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: arekm@maven.pl, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200808041845.10893.arekm@maven.pl> <20080804.143541.96067332.davem@davemloft.net> <200808050010.45615.rjw@sisk.pl>
In-Reply-To: <200808050010.45615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808050040.09726.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of August 2008, Rafael J. Wysocki wrote:
> On Monday, 4 of August 2008, David Miller wrote:
> > From: Arkadiusz Miskiewicz <arekm@maven.pl>
> > Date: Mon, 4 Aug 2008 18:45:10 +0200
> > 
> > > 
> > > git kernel, pulled around  Sat Aug 2 13:32:05 CEST,
> > > i686, thinkpad z60m notebook
> > 
> > Obviously the tg3 PCI power-management changes were totally untested.
> 
> If you mean the commit below, actually they were tested.
> 
> I run this code on a regular basis on my production box and I have never seen
> this stack trace.  How exactly can I make it appear?

OK, I see.  I must have overlooked it. :-/  Sorry again.

Rafael
