Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXBDW0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXBDW0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXBDW0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:26:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54570 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbXBDW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:26:32 -0500
Date: Sun, 4 Feb 2007 22:39:10 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Patrick Ale" <patrick.ale@gmail.com>
Cc: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: More pata_ stuff
Message-ID: <20070204223910.7eaf5136@localhost.localdomain>
In-Reply-To: <8d158e1f0702041159m45a70303lf0fc3ce71b8f946a@mail.gmail.com>
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	<45C619FC.3040804@shaw.ca>
	<8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	<200702041910.46421.s0348365@sms.ed.ac.uk>
	<20070204193441.6746bbca@localhost.localdomain>
	<8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
	<20070204194909.136dccc5@localhost.localdomain>
	<8d158e1f0702041139k658e6d6dv52e7b3c68ef146e1@mail.gmail.com>
	<8d158e1f0702041159m45a70303lf0fc3ce71b8f946a@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007 20:59:23 +0100
"Patrick Ale" <patrick.ale@gmail.com> wrote:

> On 2/4/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> > On 2/4/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > \
> > > OLDPIIX is for "old" PIIX devices only - from pentium era. It does not
> > > cover the later chips at all
> 
> Just to make sure, this is a P2 SMP board, Slot A, doesnt even support P3 CPUs.
> The board is something like, 5 years old or so. Which driver *should*
> work for me?
> 
> The board even has *gasp* ISA slots and doesnt support anything more
> than UDMA33 :D

Send an lspci -vvxxx and it'll be easy to tell, or to find out if you
have a variant which has been overlooked
