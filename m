Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZG0V5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZG0V5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZG0V5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:57:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZG0V5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:57:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [Bug #13475] suspend/hibernate lockdep warning
Date: Mon, 27 Jul 2009 23:57:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.0KH.4XObKB@chimera> <20090727165228.GC25626@Krystal>
In-Reply-To: <20090727165228.GC25626@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907272357.38609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Mathieu Desnoyers wrote:
> It should be fixed now by recents commits to the cpufreq tree, which got  
> into mainline: 
> 
> 42a06f2166f2f6f7bf04f32b4e823eacdceafdc9
> b253d2b2d28ead6fed012feb54694b3d0562839a
> b14893a62c73af0eca414cfed505b8c09efc613c
> 7d26e2d5e2da37e92c6c7644b26b294dedd8c982
> 37c90e8887efd218dc4af949b7f498ca2da4af9f
> 5a75c82828e7c088ca6e7b4827911dc29cc8e774
> ee88415caf736b89500f16e0a545614541a45005
> 3f4a782b5ce2698b1870b5a7b573cd721d4fce33
> 5e1596f75395e7a402e1059c518e633d2732dcf8

Thanks, closed.

Rafael
