Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbXFFQYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbXFFQYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXFFQYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:24:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:59744 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751325AbXFFQY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:24:29 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19c6KN5FqtcuElzcy9dcjSb0kYSEyq+I0yWgqMXsc
	iZ1tsiqsYhNKBl
Date: Wed, 6 Jun 2007 18:24:26 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070606162425.GA3943@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070606154442.GB13166@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.06 12:44:42 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 06 Jun 2007, Robert Hancock wrote:
> > >I used kernel 2.6.21 with the libata PIIX SATA driver and a
> > >Seagate ST98823AS drive.
> > 
> > Yes, that's expected if the drive rejects the command.
> 
> Are *all* SATA drives rejecting the command?  Mine doesn't accept it,
> either.  And it should, AFAIK, unless IBM's HDAPS-enabled firmware started
> ripping out accousting management from Hitachi drives, which I don't find
> very likely...

Works here, using a WDC WD1600AAJS-00PSA0 and sata_nv.

Björn
