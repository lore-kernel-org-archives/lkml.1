Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXHBHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXHBHOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXHBHOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:14:06 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57507 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbXHBHOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:14:05 -0400
Date: Thu, 2 Aug 2007 09:11:12 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
Cc: Matthew Hawkins <darthmdh@gmail.com>, Rene Herman <rene.herman@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       CK Mailinglist <ck@vds.kolivas.org>, Andi Kleen <andi@firstfloor.org>,
       Indan Zupancic <indan@nul.nu>
Subject: Re: [ck] Re: Linux Kernel cfs scheduler and xorg kbd
Message-ID: <20070802091112.4e606550@frecb000686.frec.bull.fr>
In-Reply-To: <1185983612.16632.14.camel@xtower.fri>
References: <1185827130.26459.16.camel@xtower.fri>
	<20070801064816.GC10134@elte.hu>
	<p73abtbpk2s.fsf@bingen.suse.de>
	<46B06815.10200@gmail.com>
	<46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
	<46B0818F.10204@gmail.com>
	<49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
	<46B08B95.2010405@kvitka.net>
	<46B09190.1070201@gmail.com>
	<1185979460.16632.9.camel@xtower.fri>
	<b21f8390708010800i40b0281dv77c82f3c75fb0a89@mail.gmail.com>
	<1185983612.16632.14.camel@xtower.fri>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 02/08/2007 09:18:52,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 02/08/2007 09:18:53,
	Serialize complete at 02/08/2007 09:18:53
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi all,

  just a datapoint FWIW

On Wed, 01 Aug 2007 17:53:32 +0200 "<::.. Teresa_II ..::>" <teresa@kvitka.net> wrote:

> У чт, 2007-08-02 у 01:00 +1000, Matthew Hawkins пише:
> 
> > Are you sure its not just a setting in Gnome/KDE for accessibility?
> > That tends to do crazy things like making control keys sticky...
> 
> Yes, i use gnome, and all keyboard layouts are set in gnome, also group
> switching for layouts. But accessibility is switched completely off.
> 

  This reminds me I had something similar happening about a year or so ago
running with Debian's unstable xorg and gnome.

  The keys would stick for a short time (no, no coffee spilled on the keyboard,
I can assure you ;-), the most annoying one being the delete key. Nothing
deterministic, it could happen anytime (or not at all for several days).

  As a final resort, I upgraded the xorg and gnome packages - problem solved.

  Sébastien.
