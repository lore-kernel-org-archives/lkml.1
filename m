Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbZA2WgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbZA2WgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZA2Wfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:35:51 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:61769 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZA2Wfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=X4FhLFG98wSe5L+NHcrW1BSK59rCDJIbbdgnZsxebUp/BAkxyXeEfjYQdw2D4DeOZR
         uR/zC9gy9WuAuHrRTih8/whluwjoxFSsAZgYPlWaJwMqvl4iIDsouPcPJTCpwMKQ3Zv3
         Rous8G03JuF0AVMG7Ykm7nn1w4uhC05Nmk2qg=
Date: Thu, 29 Jan 2009 17:35:44 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: Matt Carlson <mcarlson@broadcom.com>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <20090129222247.GA13861@xw6200.broadcom.net>
Message-ID: <alpine.DEB.2.00.0901291730030.5149@parag-desktop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <alpine.LFD.2.00.0901281636270.3123@localhost.localdomain> <alpine.DEB.2.00.0901282049040.5026@parag-desktop> <20090129184215.GA13459@xw6200.broadcom.net> <alpine.DEB.2.00.0901291700130.5149@parag-desktop>
 <20090129222247.GA13861@xw6200.broadcom.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Matt Carlson wrote:

> FWIW, I can suspend and resume using the latest linux-2.6 kernel
> on a machine with a similar chip here.  The problem doesn't seem to
> affect all Broadcom devices.

It is failing for me on HP xw6600 workstation, if that helps in any way.

Parag
