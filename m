Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbXBDTgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbXBDTgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXBDTgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:36:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505AbXBDTgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:36:31 -0500
Date: Sun, 4 Feb 2007 19:49:09 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Patrick Ale" <patrick.ale@gmail.com>
Cc: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: More pata_ stuff
Message-ID: <20070204194909.136dccc5@localhost.localdomain>
In-Reply-To: <8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	<45C619FC.3040804@shaw.ca>
	<8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	<200702041910.46421.s0348365@sms.ed.ac.uk>
	<20070204193441.6746bbca@localhost.localdomain>
	<8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought PATA_OLDPIIX would be it, like it is just that for VIA,SIL
> and Promise.

OLDPIIX is for "old" PIIX devices only - from pentium era. It does not
cover the later chips at all
