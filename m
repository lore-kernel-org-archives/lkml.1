Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZALMsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZALMsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZALMrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:47:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbZALMrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:47:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin =?iso-8859-15?q?MOKREJ=A6?= 
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: [Bug #12410] resource map sanity check conflict: 0x7fffff00 0x800000ff 0x7ffff000 0x7fffffff ACPI Non-volatile Storage
Date: Mon, 12 Jan 2009 13:47:25 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.D7.SafaJB@chimera> <496B2A02.6030009@ribosome.natur.cuni.cz>
In-Reply-To: <496B2A02.6030009@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901121347.26362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Martin MOKREJ¦ wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12410
> > Subject		: resource map sanity check conflict: 0x7fffff00 0x800000ff 0x7ffff000 0x7fffffff ACPI Non-volatile Storage
> > Submitter	: Martin MOKREJ¦ <mmokrejs@ribosome.natur.cuni.cz>
> > Date		: 2008-12-30 14:56 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123064945018849&w=4
> 
> The above bug is gone from 2.6.29-rc1.

Thanks for the update, the bug has been closed.

Rafael
