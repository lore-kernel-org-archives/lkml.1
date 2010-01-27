Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437Ab0A0Aw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0A0Aw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951Ab0A0Aw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:52:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0A0AwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:52:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maciej Sitarz <macieks@freesco.pl>
Subject: Re: [Bug #14748] e1000e NIC not working after reboot
Date: Wed, 27 Jan 2010 01:52:56 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc5-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.JGB.haMXLB@chimera> <4B5F706B.60905@freesco.pl>
In-Reply-To: <4B5F706B.60905@freesco.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001270152.56316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Maciej Sitarz wrote:
> On 24.01.2010 23:22, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> 
> The problem still exist I'm using kernel version 2.6.32.6 now.
> 
> I have one more observation:
> After the reboot, when the NIC is not working, both leds are on. Not 
> blinking, they light all the time, even if I remove the plug.

Thanks for the update.

Rafael
