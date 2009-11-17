Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZKQWoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZKQWoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZKQWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:44:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbZKQWoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:44:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: [Bug #14577] Data Corruption with Adaptec 52445, Firmware 5.2-0 (17380)
Date: Tue, 17 Nov 2009 23:45:43 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.3eG.ETdALB@chimera> <20091117122726.GH26279@TechFak.Uni-Bielefeld.DE>
In-Reply-To: <20091117122726.GH26279@TechFak.Uni-Bielefeld.DE>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172345.43163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Lukas Kolbe wrote:
> Rafael J. Wysocki wrote:
> 
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.31.  Please verify if it still should be listed and let me know
> >(either way).
> 
> It is still valid. We haven't yet been able to verify if it is either a
> hardware problem (working with the adaptec folks to sort that out) or a
> kernel problem (working with you to find that out ;). Kernel 2.6.30, as
> already said, seems to think everything is fine, so it really might be a
> regression.
> 
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14577
> >Subject		: Data Corruption with Adaptec 52445, Firmware 5.2-0 (17380)
> >Submitter	:  <lkolbe@techfak.uni-bielefeld.de>
> >Date		: 2009-11-10 13:31 (7 days old)

Thanks for the update.

Rafael
