Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZEaCT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZEaCT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 22:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZEaCTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 22:19:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:51981 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753658AbZEaCTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 22:19:19 -0400
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX19B0EoKcqRBUBrttWZba4+Yaey46k2D0jc01wRBlT
	4LsbW0Bbo1YPDY
Date: Sun, 31 May 2009 04:19:12 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [Bug #13371] s2disk hangs with e100, kernel 2.6.29 and later
Message-ID: <20090531021912.GA11361@arbonne.lan>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	"Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A.i1F.bVbIKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PkPeJtNB3KO.A.i1F.bVbIKB@chimera> <20090525230259.GA5098@vilya>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is still present.

On Sat, May 30, 2009 at 09:55:39PM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13371
> Subject		: s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H

Better: s2disk hangs with e100, kernel 2.6.29 and later

> Submitter	: Richard Atterer <richard@2009.atterer.net>
> Date		: 2009-05-16 22:51 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=124251446428166&w=4
> 		  http://lkml.org/lkml/2009/5/25/253

Latest information: The e100 driver is responsible for the problem. 
http://lkml.org/lkml/2009/5/25/440

Maybe handled by: Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
:)

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer
  | \/¯|  http://atterer.net
  ¯ '` ¯
