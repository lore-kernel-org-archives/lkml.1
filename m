Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYHXVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYHXVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYHXVJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:09:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYHXVJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:09:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #11379] char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Sun, 24 Aug 2008 23:12:46 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.RSH.faGsIB@albercik> <200808240818.09275.elendil@planet.nl>
In-Reply-To: <200808240818.09275.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808242312.47547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of August 2008, Frans Pop wrote:
> On Saturday 23 August 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11379
> > Subject	: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2008-08-18 13:40 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121906698213329&w=4
> > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Fixed with:
> commit 5e4c6564c95ce127beeefe75e15cd11c93487436
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Thu Aug 21 15:28:56 2008 +0200
> 
>     pnp: fix "add acpi:* modalias entries"

Thanks,  closed.

Rafael
