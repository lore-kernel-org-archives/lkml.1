Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZHTO6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZHTO6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZHTO6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:58:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38272 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZHTO6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:58:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Subject: Re: [Bug #13940] iwlagn and sky2 stopped working, ACPI-related
Date: Thu, 20 Aug 2009 16:59:37 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.74.DOIjKB@chimera> <200908200054.36939.storm@sys49152.net>
In-Reply-To: <200908200054.36939.storm@sys49152.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201659.37112.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Ricardo Jorge da Fonseca Marques Ferreira wrote:
> Yes, 2.6.31-rc6 still has the bug.

Thanks for the update.

Rafael


> On Wednesday 19 August 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
> > Subject		: iwlagn and sky2 stopped working, ACPI-related
> > Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
> > Date		: 2009-08-07 22:33 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4
