Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXJ2Esf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXJ2Esf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXJ2EsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:48:13 -0400
Received: from lixom.net ([66.141.50.11]:38980 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbXJ2EsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:48:12 -0400
Date: Sun, 28 Oct 2007 23:56:10 -0500
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: nr_slabs is an atomic_long_t
Message-ID: <20071029045610.GA16100@lixom.net>
References: <20071029131540.13932677.sfr@canb.auug.org.au> <Pine.LNX.4.64.0710281953460.28636@schroedinger.engr.sgi.com> <20071029142430.fd711666.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029142430.fd711666.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 02:24:30PM +1100, Stephen Rothwell wrote:
> On Sun, 28 Oct 2007 19:53:55 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> >
> > That was already fixed AFAICT.
> 
> Not in Linus' tree, yet.

Nope, it's still sitting in -mm. Al Viro just posted the same fix too.


-Olof
