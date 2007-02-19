Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbXBSQjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbXBSQjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXBSQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:39:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:49061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405AbXBSQjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:39:04 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: [PATCH] i386 make NMI use PERFCTR1 for architectural perfmon
Date: Mon, 19 Feb 2007 17:38:57 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070217160656.GA16715@frankl.hpl.hp.com> <200702181756.05672.ak@suse.de> <20070219163624.GB30233@frankl.hpl.hp.com>
In-Reply-To: <20070219163624.GB30233@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702191738.57870.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 February 2007 17:36, Stephane Eranian wrote:
> Andi,
> 
> On Sun, Feb 18, 2007 at 05:56:05PM +0100, Andi Kleen wrote:
> > On Saturday 17 February 2007 17:06, Stephane Eranian wrote:
> > > Hello,
> > > 
> > > This patch against 2.6.20 
> > 
> > Please always submit against mainline:
> > 
> Isn't 2.6.20 the latest mainline?

ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.20-git* is

> Do you want me to resubmit?

Yes please.

-Andi
