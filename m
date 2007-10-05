Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbXJEUYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbXJEUYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762304AbXJEUX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:23:56 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:60218 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761666AbXJEUXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:23:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Cute feature: colored printk output
Date: Fri, 5 Oct 2007 13:23:47 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E27016250DE@az33exm24.fsl.freescale.net>
In-Reply-To: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Cute feature: colored printk output
Thread-Index: AcgHg+r4s8OAMtIUQZqNAf/CsHBGwQACVz6A
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jan 
> Engelhardt
> Sent: Friday, October 05, 2007 2:14 PM
> To: Linux Kernel Mailing List
> Cc: Andrew Morton
> Subject: [PATCH] Cute feature: colored printk output
> 
> 
> Colored kernel message output
> 
> Let's work more on Linux's cuteness! 
> [http://lkml.org/lkml/2007/10/4/431]
> The following patch makes it possible to give kernel messages a
> selectable color which helps to distinguish it from other noise,
> such as boot messages. NetBSD has it, OpenBSD has it, FreeBSD to some
> extent, so I think Linux should too.
> 
> Inspired by cko (http://freshmeat.net/p/cko/), but independently
> written, later contributed forth and back.
> 
> Already posted at: http://lkml.org/lkml/2007/4/1/162
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>


I like it. A somewhat related nice feature would be to print different
loglevels with different colors.


Cheers,
Emil.
