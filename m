Return-Path: <linux-kernel-owner+w=401wt.eu-S965227AbXFFVgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227AbXFFVgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964928AbXFFVgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:36:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:49578 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964899AbXFFVgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:36:20 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX194eo5MWTx4Hiy7DyE0Xg4W82JwSoFvPQx102AITd
	4jZMzgGnHtltbZ
Date: Wed, 6 Jun 2007 23:36:18 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070606213617.GA6580@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net> <20070606162425.GA3943@atjola.homenet> <20070606164854.GA18984@khazad-dum.debian.net> <20070606175112.GA4659@atjola.homenet> <20070606210337.GA31549@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070606210337.GA31549@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.06 18:03:37 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 06 Jun 2007, Björn Steinbrink wrote:
> > On 2007.06.06 13:48:54 -0300, Henrique de Moraes Holschuh wrote:
> > > I am also using libata PIIX like the first person reporting the problem, but
> > > it is a PATA drive behind a SATA-PATA bridge (it is a IBM T43 notebook).
> > > Hmm...
> > 
> > Also works fine on my T43 using ata_piix and a HTS541040G9AT00. Kernel
> > 2.6.22-rc1.
> 
> Which firmware in the HD? I need the fourth letter.  If it is "I", it is
> HDAPS firmware.  If it is "O", it is regular OEM firmware (no Unload
> Immediate support).
> 
> hdparm, and even /proc/scsi/scsi will tell you enough of the firmware
> revision to get to the fourth letter.

HDAPS support is available, revision is MB2IA60A.

Björn
