Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbXETSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbXETSgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbXETSgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:36:06 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:29353 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbXETSgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:36:05 -0400
Message-ID: <11f674920705201136p5e8aefa5o84766b2efe9982b4@mail.gmail.com>
Date: Sun, 20 May 2007 11:36:05 -0700
From: "Kevin Bowling" <lkml@kev009.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc2-v1
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1179645902.21827.16.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179645902.21827.16.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> I'm pleased to announce an updated version of the x86_64 highres/dyntick
> support patches against 2.6.22-rc2:
>
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc2-x86_64-highres-v1.patch
>
> Broken out version is available here:
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc2-x86_64-highres-v1.patches.tar.bz2
>
> Changes since the last version:
>
> - update to -rc2
> - maxcpus=1 boot hang fix
>
>
> Comments, bug reports, patches are welcome as usual

Links fixed: http://www.tglx.de/projects/hrtimers/2.6.22-rc2/

http://www.tglx.de/projects/hrtimers/2.6.22-rc2/patch-2.6.22-rc2-hrt2.patch
http://www.tglx.de/projects/hrtimers/2.6.22-rc2/patch-2.6.22-rc2-hrt2.patches.tar.bz2
