Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZHZU5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZHZU5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZHZU5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:57:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZHZU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:57:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Subject: Re: [Bug #13940] iwlagn and sky2 stopped working, ACPI-related
Date: Wed, 26 Aug 2009 22:58:05 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.UX.YtGlKB@chimera> <200908260100.57360.storm@sys49152.net>
In-Reply-To: <200908260100.57360.storm@sys49152.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262258.05375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Ricardo Jorge da Fonseca Marques Ferreira wrote:
> A patch has been proposed in the bugreport that fixes the problem, so if the 
> patch is commited, the regression is fixed for me. I don't think the patch was 
> commited yet.

Well, honestly, it doesn't seem it will be applied.

Thanks for the update anyway.

Rafael


> On Tuesday 25 August 2009, Rafael J. Wysocki wrote:
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
> > Date		: 2009-08-07 22:33 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4
