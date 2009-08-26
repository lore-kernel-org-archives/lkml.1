Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZHZADi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZHZADi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZHZADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:03:38 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42379 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZHZADh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:03:37 -0400
From: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13940] iwlagn and sky2 stopped working, ACPI-related
Date: Wed, 26 Aug 2009 01:00:57 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc6-22-default; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.UX.YtGlKB@chimera>
In-Reply-To: <_yaHeGjHEzG.A.UX.YtGlKB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908260100.57360.storm@sys49152.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch has been proposed in the bugreport that fixes the problem, so if the 
patch is commited, the regression is fixed for me. I don't think the patch was 
commited yet.

On Tuesday 25 August 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
> Subject		: iwlagn and sky2 stopped working, ACPI-related
> Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
> Date		: 2009-08-07 22:33 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4
> 

