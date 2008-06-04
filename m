Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYFDEQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYFDEQC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYFDEPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:15:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYFDEPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:15:53 -0400
Date: Tue, 3 Jun 2008 21:15:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: avorontsov@ru.mvista.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, wim@iguana.be,
       scottwood@freescale.com
Subject: Re: [PATCH 0/8 v4] mpc83xx_wdt rework, support for mpc8610 and
 mpc8xx
Message-Id: <20080603211530.d6b3755a.akpm@linux-foundation.org>
In-Reply-To: <18502.5368.786188.835122@cargo.ozlabs.ibm.com>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
	<20080603164830.32457962.akpm@linux-foundation.org>
	<20080604001739.GB24548@polina.dev.rtsoft.ru>
	<20080603173214.0bf71571.akpm@linux-foundation.org>
	<18502.5368.786188.835122@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 14:07:20 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Looking at Linus' git tree, it's evident that some subsystems use the
> the "[SUBSYSTEM]" notation and some use "subsystem:".  If there is now
> an edict from on high that only "subsystem:" is acceptable, then I
> must have missed that memo.

I'm all edicted out.  Sometimes one just puts forth the reasoning and
lets others decide whether it's worth bothering about.  I could understand
that decision being "no" :)
