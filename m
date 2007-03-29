Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXC2QWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXC2QWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXC2QWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:22:12 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:47034 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbXC2QWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:22:11 -0400
Date: Thu, 29 Mar 2007 11:21:46 -0500
From: Scott Wood <scottwood@freescale.com>
To: Rick Brown <rick.brown.3@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       linux-newbie@vger.kernel.org
Subject: Re: regarding kernel preemption
Message-ID: <20070329162146.GA32670@ld0162-tx32.am.freescale.net>
References: <7783925d0703290905u1e4d94f2v88d6f1736c52de81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7783925d0703290905u1e4d94f2v88d6f1736c52de81@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 09:35:13PM +0530, Rick Brown wrote:
> When we preempt_enable() / preempt_disable(), is the kernel preemption
> enabled or disabled for ALL the processors or just the local
> processor?

Just the local processor.

-Scott
