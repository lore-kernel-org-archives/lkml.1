Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbXF1DRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbXF1DRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759348AbXF1DRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:17:03 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:58819 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbXF1DRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:17:00 -0400
Date: Wed, 27 Jun 2007 23:06:03 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Subject: Re: Userspace compiler support of "long long"
Message-ID: <20070628030603.GC6805@fattire.cabal.ca>
References: <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com> <20070627155715.60ebc48f.randy.dunlap@oracle.com> <20070627161648.52d3786d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627161648.52d3786d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 04:16:48PM -0700, Randy Dunlap wrote:
> > LDD3 ch. 11 says that long on Sparc64 is 32 bits.
> > Same for "ppc" (don't know which power* arch. they mean by that).
> 
> Hm, I suppose that table only applies to userspace, not kernel...
> 

Doing 64-bit Linux non-LP64 would be an interesting exercise in masochism...
