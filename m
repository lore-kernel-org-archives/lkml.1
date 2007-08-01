Return-Path: <linux-kernel-owner+w=401wt.eu-S1765556AbXHATPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765556AbXHATPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764274AbXHATP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:15:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762151AbXHATP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:15:26 -0400
Date: Wed, 1 Aug 2007 21:15:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
Message-ID: <20070801191524.GE20713@one.firstfloor.org>
References: <11859243121617-git-send-email-clameter@sgi.com> <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com> <20070801182611.GB20713@one.firstfloor.org> <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com> <20070801184026.GC20713@one.firstfloor.org> <Pine.LNX.4.64.0708011144450.22867@schroedinger.engr.sgi.com> <20070801185741.GD20713@one.firstfloor.org> <Pine.LNX.4.64.0708011158110.24852@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011158110.24852@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 11:58:44AM -0700, Christoph Lameter wrote:
> On Wed, 1 Aug 2007, Andi Kleen wrote:
> 
> > That might be on your systems, but for a mainline submission the
> > standards are higher.
> 
> Right that is why I asked for someone to take it over and do mainline work 
> if that is wanted. I had a couple of requests for these patches.

The easiest way to solve this would be to switch to reporting cycles.
That would simplify your patch in fact.

-Andi
