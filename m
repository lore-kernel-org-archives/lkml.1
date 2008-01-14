Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYANVQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYANVQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYANVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:15:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491AbYANVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:15:45 -0500
Date: Mon, 14 Jan 2008 13:15:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: Poonam.Aggrwal@freescale.com, sfr@canb.auug.org.au, rubini@vision.unipv.it,
       linux-ppcdev@ozlabs.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kumar.gala@freescale.com,
       Michael.Barkowski@freescale.com, ashish.kalra@freescale.com,
       Rich.Cutler@freescale.com
Subject: Re: [PATCH 0/3] UCC TDM driver for MPC83xx platforms
Message-Id: <20080114131530.9d33f50a.akpm@linux-foundation.org>
In-Reply-To: <20080114120051.3207043b.kim.phillips@freescale.com>
References: <FBA61160C48B8D438F3323FEFB4EF2C259F2F6@zin33exm24.fsl.freescale.net>
	<FBA61160C48B8D438F3323FEFB4EF2C26E7653@zin33exm24.fsl.freescale.net>
	<20080114120051.3207043b.kim.phillips@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 12:00:51 -0600
Kim Phillips <kim.phillips@freescale.com> wrote:

> On Thu, 10 Jan 2008 21:41:20 -0700
> "Aggrwal Poonam" <Poonam.Aggrwal@freescale.com> wrote:
> 
> > Hello  All
> > 
> > I am waiting for more feedback on the patches.
> > 
> > If there are no objections please consider them for 2.6.25.
> > 
> if this isn't going to go through Alessandro Rubini/misc drivers, can
> it go through the akpm/mm tree?
> 

That would work.  But it might be more appropriate to go Kumar->paulus->Linus.
