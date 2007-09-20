Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXITKND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXITKND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXITKMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:12:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47948 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXITKMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:12:52 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 20 Sep 2007 06:11:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: =?iso-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
cc: Matt LaPlante <kernel1@cyberdogtech.com>, linux-kernel@vger.kernel.org
Subject: Re: A little coding style nugget of joy
In-Reply-To: <46F23B77.40809@draigBrady.com>
Message-ID: <Pine.LNX.4.64.0709200610180.15327@localhost.localdomain>
References: <20070919123401.9369534d.kernel1@cyberdogtech.com>
 <46F23B77.40809@draigBrady.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2001575627-1190283081=:15327"
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2001575627-1190283081=:15327
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 20 Sep 2007, Pádraig Brady wrote:

> Matt LaPlante wrote:
> > Since everyone loves random statistics, here are a few gems to give you a break from your busy day:
> >
> > Number of lines in the 2.6.22 Linux kernel source that include one or more trailing whitespaces: 135209
> > Bytes saved by removing said whitespace: 151809
> > Lines in the (unified) diff: 455437
> > Size of the diff: 15M
> > People brave enough to submit the patch: ~0
>
> It's gradually getting better so:
> http://lwn.net/2001/1129/a/whitespace.php3

and you wouldn't *believe* how much space you can save by getting rid
of all that annoying indentation.  and don't even get me *started* on
those comments ...

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
--8323328-2001575627-1190283081=:15327--
