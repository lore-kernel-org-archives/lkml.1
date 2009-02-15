Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZBOK3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZBOK3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZBOK32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:29:28 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39784 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZBOK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:29:28 -0500
Date: Sun, 15 Feb 2009 11:31:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] scripts: add x86 register parser to markup_oops.pl
Message-ID: <20090215103118.GA31088@uranus.ravnborg.org>
References: <20090113150103.085c6eb6@infradead.org> <20090113150148.7d3fc379@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113150148.7d3fc379@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:01:48PM +0000, Arjan van de Ven wrote:
> From ace27f35478ed449fd345d2381411362f6bcc9f9 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 13 Jan 2009 05:50:35 +0000
> Subject: [PATCH] scripts: add x86 register parser to markup_oops.pl
> 
> An oops dump also contains the register values.
> This patch parses these for (32 bit) x86, and then annotates the
> disassembly with these values; this helps in analysis of the oops
> by the developer, for example, NULL pointer or other pointer bugs
> show up clearly this way.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Added to kbuild-fixes.git

	Sam
