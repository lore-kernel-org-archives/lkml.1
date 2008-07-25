Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbYGYGRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbYGYGRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 02:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYGYGRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 02:17:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbYGYGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 02:17:12 -0400
Date: Thu, 24 Jul 2008 23:15:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Let HP iLO driver depend on PCI
Message-Id: <20080724231519.b4553fa1.akpm@linux-foundation.org>
In-Reply-To: <20080725153502.283aae1f.sfr@canb.auug.org.au>
References: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com>
	<20080724215652.24e4e550.akpm@linux-foundation.org>
	<20080725153502.283aae1f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 15:35:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Thu, 24 Jul 2008 21:56:52 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Three weeks and nobody did an allmodconfig build on linux-next for s390
> > or m68k (at least).
> 
> http://kisskb.ellerman.id.au/kisskb/branch/9/
> 

Wow, lots of red.

May I revise my comment?  Three weeks and nobody did anything about the
failing allmodconfig builds on linux-next and s390 (at least).

Is anyone actively monitoring that page and doing the requisite culprit-poking?

