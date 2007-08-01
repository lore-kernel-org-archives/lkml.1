Return-Path: <linux-kernel-owner+w=401wt.eu-S1763756AbXHAS3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763756AbXHAS3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbXHAS3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:29:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56031 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755344AbXHAS3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:29:35 -0400
Date: Wed, 1 Aug 2007 11:29:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
In-Reply-To: <20070801182611.GB20713@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com>
References: <11859243121617-git-send-email-clameter@sgi.com>
 <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com>
 <20070801182611.GB20713@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Andi Kleen wrote:

> > But then the numbers are not comparable across systems.
> 
> That would only matter if you're interested in absolute system
> performance of different systems.

Yes I am definitely interested in seeing which type of cpu runs a certain 
section faster.

> If you want absolute comparable system performance benchmarks I don't think
> micro-instrumenting the kernel is a good approach.

It is certainly interesting to compare alternative ways of handling the 
instruction streams by various processors or models of processors.
