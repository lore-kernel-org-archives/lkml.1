Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbZLKWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbZLKWMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761170AbZLKWMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:12:48 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:43825 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761066AbZLKWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:12:47 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: K8 ECC error with linux-2.6.32
Date: Fri, 11 Dec 2009 23:12:49 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32-fglrx; KDE/4.3.80; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <200912112239.05446.johannes.hirte@fem.tu-ilmenau.de> <20091211220756.GA12795@liondog.tnic>
In-Reply-To: <20091211220756.GA12795@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112312.49902.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 11 Dezember 2009 23:07:56 schrieb Borislav Petkov:
> On Fri, Dec 11, 2009 at 10:39:04PM +0100, Johannes Hirte wrote:
> > Am Freitag 11 Dezember 2009 22:19:38 schrieb Borislav Petkov:
> > > On Fri, Dec 11, 2009 at 10:02:47PM +0100, Johannes Hirte wrote:
> > > > With kernel 2.6.32 I get now:
> > > >
> > > > Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
> > > > Dec 11 21:26:37 datengrab kernel: K8 ECC error.
> > >
> > > Is that all, i.e. do you have anything else in the logs. For example, a
> > > line which contains "MC?_STATUS: ..." or similar.
> >
> > No, nothing else.
> >
> > > Please send the whole
> > > dmesg.
> >
> > It's the log from syslog-ng, but with all dmesg log captured.
> 
> how about doing
> 
> dmesg > dmesg.log
> 
> instead?
> 
> Please send both logs (flgrx and radeon+kms).

Will do so, but it will take some time, cause for radeon I have to rebuild X 
(gentoo). Don't expect to much. From my memories, there wasn't any more 
messages in dmesg. :(


regards,
  Johannes
